;; NFT Royalty Distributor (Phase 2 - Enhanced)
;; Enhanced security, bug fixes, and new functionality

;; Error constants
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-percent (err u101))
(define-constant err-collection-not-found (err u102))
(define-constant err-insufficient-balance (err u103))
(define-constant err-transfer-failed (err u104))
(define-constant err-already-registered (err u105))
(define-constant err-invalid-amount (err u106))
(define-constant err-contract-paused (err u107))

;; Contract owner
(define-constant contract-owner tx-sender)

;; Contract state
(define-data-var contract-paused bool false)
(define-data-var total-collections uint u0)

;; Data map for registered collections
(define-map collections
  principal
  (tuple 
    (receiver principal) 
    (percent uint)
    (total-distributed uint)
    (active bool)
    (registration-height uint)
  )
)

;; Track distribution history
(define-map distribution-history
  { collection: principal, height: uint }
  (tuple (amount uint) (timestamp uint))
)

;; Events for tracking
(define-map collection-events
  { collection: principal, event-type: (string-ascii 20) }
  (tuple (data (string-ascii 100)) (height uint))
)

;; Define trait for royalty distribution
(define-trait royalty-receiver-trait
  (
    (distribute-royalty (principal uint) (response uint uint))
  )
)

;; Read-only functions
(define-read-only (get-collection-info (collection principal))
  (map-get? collections collection)
)

(define-read-only (get-contract-stats)
  (tuple 
    (total-collections (var-get total-collections))
    (is-paused (var-get contract-paused))
    (contract-owner contract-owner)
  )
)

(define-read-only (get-distribution-history (collection principal) (height uint))
  (map-get? distribution-history { collection: collection, height: height })
)

(define-read-only (is-contract-paused)
  (var-get contract-paused)
)

;; Private functions
(define-private (log-event (collection principal) (event-type (string-ascii 20)) (data (string-ascii 100)))
  (map-set collection-events 
    { collection: collection, event-type: event-type }
    { data: data, height: block-height }
  )
)

;; Public functions

;; Enhanced register-collection with bug fixes and security improvements
(define-public (register-collection (creator principal) (receiver principal) (percent uint))
  (begin
    ;; Check if contract is paused
    (asserts! (not (var-get contract-paused)) err-contract-paused)
    
    ;; Fix bug: Check authorization properly
    (asserts! (is-eq tx-sender creator) err-unauthorized)
    
    ;; Fix bug: Validate percentage is between 0 and 100 (was allowing 0)
    (asserts! (and (> percent u0) (<= percent u100)) err-invalid-percent)
    
    ;; Security enhancement: Check if collection already registered
    (asserts! (is-none (map-get? collections creator)) err-already-registered)
    
    ;; Security enhancement: Validate receiver is not zero address
    (asserts! (not (is-eq receiver 'SP000000000000000000002Q6VF78)) err-unauthorized)
    
    ;; Register the collection
    (map-set collections creator { 
      receiver: receiver, 
      percent: percent,
      total-distributed: u0,
      active: true,
      registration-height: block-height
    })
    
    ;; Update total collections counter
    (var-set total-collections (+ (var-get total-collections) u1))
    
    ;; Log registration event
    (log-event creator "REGISTERED" "Collection registered successfully")
    
    (ok true)
  )
)

;; New functionality: Distribute royalties
(define-public (distribute-royalty (collection principal) (amount uint))
  (let (
    (collection-info (unwrap! (map-get? collections collection) err-collection-not-found))
    (receiver (get receiver collection-info))
    (percent (get percent collection-info))
    (is-active (get active collection-info))
    (royalty-amount (/ (* amount percent) u100))
    (current-height block-height)
  )
    ;; Check if contract is paused
    (asserts! (not (var-get contract-paused)) err-contract-paused)
    
    ;; Validate inputs
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! is-active err-collection-not-found)
    
    ;; Check sufficient balance
    (asserts! (>= (stx-get-balance tx-sender) royalty-amount) err-insufficient-balance)
    
    ;; Transfer royalty to receiver
    (match (stx-transfer? royalty-amount tx-sender receiver)
      success (begin
        ;; Update total distributed
        (map-set collections collection 
          (merge collection-info { total-distributed: (+ (get total-distributed collection-info) royalty-amount) })
        )
        
        ;; Record distribution history
        (map-set distribution-history 
          { collection: collection, height: current-height }
          { amount: royalty-amount, timestamp: (unwrap-panic (get-block-info? time current-height)) }
        )
        
        ;; Log distribution event
        (log-event collection "DISTRIBUTED" "Royalty distributed successfully")
        
        (ok royalty-amount)
      )
      error err-transfer-failed
    )
  )
)

;; New functionality: Update collection status
(define-public (update-collection-status (collection principal) (active bool))
  (let (
    (collection-info (unwrap! (map-get? collections collection) err-collection-not-found))
  )
    ;; Only collection owner can update status
    (asserts! (is-eq tx-sender collection) err-unauthorized)
    (asserts! (not (var-get contract-paused)) err-contract-paused)
    
    ;; Update collection status
    (map-set collections collection 
      (merge collection-info { active: active })
    )
    
    ;; Log status change
    (log-event collection "STATUS_UPDATED" 
      (if active "Collection activated" "Collection deactivated")
    )
    
    (ok true)
  )
)

;; New functionality: Update royalty percentage
(define-public (update-royalty-percent (collection principal) (new-percent uint))
  (let (
    (collection-info (unwrap! (map-get? collections collection) err-collection-not-found))
  )
    ;; Only collection owner can update percentage
    (asserts! (is-eq tx-sender collection) err-unauthorized)
    (asserts! (not (var-get contract-paused)) err-contract-paused)
    (asserts! (and (> new-percent u0) (<= new-percent u100)) err-invalid-percent)
    
    ;; Update royalty percentage
    (map-set collections collection 
      (merge collection-info { percent: new-percent })
    )
    
    ;; Log percentage change
    (log-event collection "PERCENT_UPDATED" "Royalty percentage updated")
    
    (ok true)
  )
)

;; Admin functions for contract management
(define-public (pause-contract)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (var-set contract-paused true)
    (ok true)
  )
)

(define-public (unpause-contract)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (var-set contract-paused false)
    (ok true)
  )
)

;; Emergency function to deactivate a collection (admin only)
(define-public (emergency-deactivate-collection (collection principal))
  (let (
    (collection-info (unwrap! (map-get? collections collection) err-collection-not-found))
  )
    ;; Only contract owner can emergency deactivate
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    
    ;; Deactivate collection
    (map-set collections collection 
      (merge collection-info { active: false })
    )
    
    ;; Log emergency deactivation
    (log-event collection "EMERGENCY_DEACTIVATE" "Collection emergency deactivated by admin")
    
    (ok true)
  )
)
