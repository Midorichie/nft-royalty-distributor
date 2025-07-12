;; NFT Royalty Distributor (Phase 1 structure)

;; Error constants
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-percent (err u101))

;; Data map for registered collections
(define-map collections
  principal
  (tuple (receiver principal) (percent uint))
)

;; Public function to register a collection
(define-public (register-collection (creator principal) (receiver principal) (percent uint))
  (begin
    (if (is-eq tx-sender creator)
        (if (<= percent u100)
            (begin
              (map-set collections creator { receiver: receiver, percent: percent })
              (ok true))
            err-invalid-percent)
        err-unauthorized)))
