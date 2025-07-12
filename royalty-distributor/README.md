# NFT Royalty Distributor

A smart contract on the Stacks blockchain using Clarity, built to manage NFT royalty registration and distribution.

## Features (Phase 1)
- Register NFT collections with royalty receiver and percentage
- Access-controlled: only creators can register
- Validation on percentage limits

## Project Setup

### Requirements
- Node.js
- Clarinet (Stacks smart contract toolkit)

### Installation

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/nft-royalty-distributor.git
cd nft-royalty-distributor

# Install Clarinet if not already
npm install -g @hirosystems/clarinet

# Test the contract
clarinet test
