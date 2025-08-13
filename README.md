# Customer Loyalty and Rewards Program

A blockchain-based loyalty and rewards system that creates interoperable loyalty points across multiple retailers, enabling transparent earning and redemption of rewards with personalized offers and coalition partnerships.

## System Overview

This system consists of five interconnected smart contracts that work together to provide a comprehensive loyalty program solution:

### Core Contracts

1. **loyalty-token.clar** - Main loyalty points token with minting, burning, and transfer capabilities
2. **retailer-registry.clar** - Manages retailer registration, verification, and status
3. **rewards-program.clar** - Core rewards logic for earning and redeeming points
4. **offer-manager.clar** - Handles personalized offers based on purchase history
5. **coalition-manager.clar** - Manages partnerships and coalition programs

## Key Features

### Interoperable Loyalty Points
- Universal loyalty token that works across all registered retailers
- Standardized point earning and redemption rates
- Cross-retailer point transfers and exchanges

### Transparent Rewards System
- All transactions recorded on blockchain for full transparency
- Real-time point balance tracking
- Immutable reward history and redemption records

### Personalized Offers
- Purchase history-based offer generation
- Targeted promotions and discounts
- Tier-based reward multipliers

### Coalition Programs
- Multi-retailer partnership support
- Shared loyalty pools and cross-promotions
- Revenue sharing mechanisms

### Fraud Prevention
- Blockchain-based verification prevents double-spending
- Retailer authentication and authorization
- Automated compliance and audit trails

## Technical Architecture

### Data Structures

\`\`\`clarity
;; Customer Profile
{
total-points: uint,
tier-level: uint,
total-spent: uint,
last-activity: uint,
retailer-history: (list 50 principal)
}

;; Retailer Profile
{
name: (string-ascii 50),
category: (string-ascii 20),
points-rate: uint,
redemption-rate: uint,
is-active: bool,
coalition-member: bool
}

;; Reward Offer
{
retailer: principal,
discount-percent: uint,
min-purchase: uint,
max-discount: uint,
expiry-block: uint,
is-active: bool
}
\`\`\`

### Point Economics

- **Earning Rate**: 1 point per STX spent (configurable per retailer)
- **Redemption Rate**: 100 points = 1 STX discount (configurable)
- **Tier Multipliers**: Bronze (1x), Silver (1.2x), Gold (1.5x), Platinum (2x)
- **Coalition Bonus**: Additional 10% points for coalition member purchases

## Getting Started

### Prerequisites

- Clarinet CLI installed
- Node.js 18+ for testing
- Stacks wallet for deployment

### Installation

1. Clone the repository
2. Install dependencies: \`npm install\`
3. Run tests: \`npm test\`
4. Deploy contracts: \`clarinet deploy\`

### Usage Examples

#### Register as a Retailer
\`\`\`clarity
(contract-call? .retailer-registry register-retailer
"Coffee Shop"
"Food & Beverage"
u100  ;; 1 point per 100 micro-STX
u100) ;; 100 points = 1 STX discount
\`\`\`

#### Earn Points from Purchase
\`\`\`clarity
(contract-call? .rewards-program earn-points
'SP1CUSTOMER...
u50000000) ;; 0.5 STX purchase
\`\`\`

#### Redeem Points for Discount
\`\`\`clarity
(contract-call? .rewards-program redeem-points
u1000  ;; Redeem 1000 points
'SP1RETAILER...) ;; At specific retailer
\`\`\`

#### Create Personalized Offer
\`\`\`clarity
(contract-call? .offer-manager create-offer
'SP1CUSTOMER...
u20        ;; 20% discount
u10000000  ;; Min 0.1 STX purchase
u5000000   ;; Max 0.05 STX discount
u1000)     ;; Expires in 1000 blocks
\`\`\`

## Testing

The system includes comprehensive tests covering:

- Token minting, burning, and transfers
- Retailer registration and management
- Point earning and redemption flows
- Offer creation and redemption
- Coalition partnership mechanics
- Error handling and edge cases

Run tests with: \`npm test\`

## Security Considerations

- All functions include proper authorization checks
- Input validation prevents invalid operations
- Rate limiting prevents abuse
- Retailer verification ensures legitimate participants
- Immutable audit trail for compliance

## Deployment

1. Configure Clarinet.toml with your network settings
2. Deploy contracts in dependency order:
    - loyalty-token.clar
    - retailer-registry.clar
    - rewards-program.clar
    - offer-manager.clar
    - coalition-manager.clar

## Contributing

Please read the PR-DETAILS.md file for contribution guidelines and development workflow.

## License

MIT License - see LICENSE file for details.
