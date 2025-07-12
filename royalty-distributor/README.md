# NFT Royalty Distributor - Phase 2

## Overview

The NFT Royalty Distributor is an enhanced smart contract system built on Stacks that enables automatic royalty distribution for NFT collections. Phase 2 introduces significant improvements including bug fixes, enhanced security measures, and a comprehensive marketplace integration.

## 🚀 New Features in Phase 2

### Core Enhancements
- **Bug Fixes**: Fixed percentage validation (now requires > 0 and <= 100)
- **Enhanced Security**: Added duplicate registration prevention and zero-address validation
- **Contract Pausing**: Emergency pause functionality for contract management
- **Distribution Tracking**: Complete history of all royalty distributions
- **Event Logging**: Comprehensive event tracking for all contract interactions

### New Functionality
- **Automatic Royalty Distribution**: Seamless integration with marketplace transactions
- **Collection Status Management**: Enable/disable collections dynamically
- **Royalty Percentage Updates**: Allow collection owners to modify royalty rates
- **Distribution History**: Track all royalty payments with timestamps
- **Admin Controls**: Emergency deactivation and contract pause capabilities

### Marketplace Integration
- **NFT Marketplace Contract**: Complete marketplace with integrated royalty payments
- **Automatic Fee Calculation**: Built-in marketplace fee handling (2.5%)
- **Listing Management**: Create, update, and cancel NFT listings
- **Purchase Flow**: Streamlined buying process with automatic royalty distribution
- **Sales History**: Complete transaction history tracking

## 📋 Requirements

- Clarinet 2.0.0 or higher
- Stacks blockchain testnet/mainnet access
- Basic understanding of Clarity smart contracts

## 🛠️ Installation

```bash
# Clone the repository
git clone https://github.com/your-username/nft-royalty-distributor.git
cd nft-royalty-distributor

# Install dependencies
clarinet requirements

# Check contract syntax
clarinet check

# Run tests
clarinet test
```

## 📖 Usage

### Core Royalty Distributor Functions

#### Register a Collection
```clarity
(contract-call? .nft-royalty-distributor register-collection 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM  ;; creator
  'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5  ;; royalty receiver
  u500)  ;; 5% royalty
```

#### Distribute Royalties
```clarity
(contract-call? .nft-royalty-distributor distribute-royalty 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM  ;; collection
  u1000000)  ;; amount in microSTX
```

#### Update Collection Status
```clarity
(contract-call? .nft-royalty-distributor update-collection-status 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM  ;; collection
  true)  ;; active status
```

### Marketplace Integration Functions

#### List an NFT
```clarity
(contract-call? .nft-marketplace list-nft 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM  ;; collection
  u1        ;; token-id
  u5000000  ;; price in microSTX
  u1000     ;; duration in blocks
  (some 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.nft-royalty-distributor))
```

#### Purchase an NFT
```clarity
(contract-call? .nft-marketplace purchase-nft 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM  ;; collection
  u1)  ;; token-id
```

## 🔒 Security Features

### Phase 2 Security Enhancements

1. **Input Validation**: All functions validate inputs and prevent invalid operations
2. **Access Control**: Proper authorization checks for all sensitive operations
3. **Duplicate Prevention**: Prevents duplicate collection registration
4. **Zero Address Protection**: Validates against zero/burn addresses
5. **Contract Pausing**: Emergency pause functionality for critical situations
6. **Balance Verification**: Ensures sufficient funds before transfers
7. **Event Logging**: Comprehensive logging for audit trails

### Error Handling

The contracts implement comprehensive error handling with descriptive error codes:

- `u100`: Unauthorized access
- `u101`: Invalid percentage (must be > 0 and <= 100)
- `u102`: Collection not found
- `u103`: Insufficient balance
- `u104`: Transfer failed
- `u105`: Collection already registered
- `u106`: Invalid amount
- `u107`: Contract paused

## 🧪 Testing

The project includes comprehensive test suites:

```bash
# Run all tests
clarinet test

# Run specific test file
clarinet test tests/nft-royalty-distributor_test.ts

# Run tests with coverage
clarinet test --coverage
```

### Test Coverage

- Registration functionality
- Royalty distribution
- Security validations
- Error handling
- Marketplace integration
- Admin functions

## 📊 Contract Statistics

### Read-Only Functions

Access contract information without transactions:

```clarity
;; Get collection information
(contract-call? .nft-royalty-distributor get-collection-info 
  'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)

;; Get contract statistics
(contract-call? .nft-royalty-distributor get-contract-stats)

;; Get marketplace statistics
(contract-call? .nft-marketplace get-marketplace-stats)
```

## 🔄 Phase 2 Improvements Summary

### Bug Fixes
- Fixed percentage validation to require values > 0
- Improved authorization checks
- Enhanced error handling

### Security Enhancements
- Added duplicate registration prevention
- Implemented zero-address validation
- Added contract pause functionality
- Enhanced access control

### New Features
- Automatic royalty distribution system
- Complete marketplace integration
- Distribution history tracking
- Event logging system
- Admin control functions

### Additional Contract
- NFT Marketplace contract with integrated royalty payments
- Automatic fee calculation and distribution
- Comprehensive listing management
- Sales history tracking

## 🚀 Deployment

### Testnet Deployment
```bash
clarinet deploy --network testnet
```

### Mainnet Deployment
```bash
clarinet deploy --network mainnet
```

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Join our Discord community
- Email: support@nft-royalty-distributor.com

## 🏗️ Architecture

### Core Components

1. **NFT Royalty Distributor**: Main contract handling royalty registration and distribution
2. **NFT Marketplace**: Integrated marketplace with automatic royalty payments
3. **Event System**: Comprehensive logging and tracking
4. **Security Layer**: Multi-layered security with pause functionality

### Data Flow

1. Collection owners register their collections with royalty details
2. Marketplace listings reference the royalty contract
3. Purchases automatically trigger royalty distribution
4. All events are logged for transparency and auditing

## 🎯 Roadmap

### Phase 3 (Planned)
- Multi-token support (SIP-009, SIP-010)
- Advanced analytics dashboard
- Batch operations for gas optimization
- Integration with popular NFT platforms

### Phase 4 (Future)
- Cross-chain compatibility
- Advanced royalty splitting
- DAO governance integration
- Mobile app development

