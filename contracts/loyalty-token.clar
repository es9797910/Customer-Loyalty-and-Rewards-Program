;; Loyalty Token Contract
;; Manages the core loyalty points token with minting, burning, and transfer capabilities

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))
(define-constant ERR-INVALID-AMOUNT (err u102))
(define-constant ERR-INVALID-RECIPIENT (err u103))

;; Data Variables
(define-data-var token-name (string-ascii 32) "Loyalty Points")
(define-data-var token-symbol (string-ascii 10) "LOYAL")
(define-data-var token-decimals uint u0)
(define-data-var total-supply uint u0)

;; Data Maps
(define-map token-balances principal uint)
(define-map authorized-minters principal bool)

;; Private Functions
(define-private (is-authorized-minter (account principal))
  (default-to false (map-get? authorized-minters account)))

;; Public Functions

;; Get token info
(define-read-only (get-name)
  (ok (var-get token-name)))

(define-read-only (get-symbol)
  (ok (var-get token-symbol)))

(define-read-only (get-decimals)
  (ok (var-get token-decimals)))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

;; Get balance of account
(define-read-only (get-balance (account principal))
  (ok (default-to u0 (map-get? token-balances account))))

;; Transfer tokens
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (let ((sender-balance (default-to u0 (map-get? token-balances sender))))
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (>= sender-balance amount) ERR-INSUFFICIENT-BALANCE)
    (asserts! (not (is-eq sender recipient)) ERR-INVALID-RECIPIENT)
    (asserts! (is-eq tx-sender sender) ERR-NOT-AUTHORIZED)

    (map-set token-balances sender (- sender-balance amount))
    (map-set token-balances recipient
      (+ (default-to u0 (map-get? token-balances recipient)) amount))

    (ok true)))

;; Mint tokens (only authorized minters)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER)
                  (is-authorized-minter tx-sender)) ERR-NOT-AUTHORIZED)

    (map-set token-balances recipient
      (+ (default-to u0 (map-get? token-balances recipient)) amount))
    (var-set total-supply (+ (var-get total-supply) amount))

    (ok true)))

;; Burn tokens
(define-public (burn (amount uint) (account principal))
  (let ((account-balance (default-to u0 (map-get? token-balances account))))
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (>= account-balance amount) ERR-INSUFFICIENT-BALANCE)
    (asserts! (or (is-eq tx-sender account)
                  (is-eq tx-sender CONTRACT-OWNER)
                  (is-authorized-minter tx-sender)) ERR-NOT-AUTHORIZED)

    (map-set token-balances account (- account-balance amount))
    (var-set total-supply (- (var-get total-supply) amount))

    (ok true)))

;; Authorize minter (only contract owner)
(define-public (authorize-minter (minter principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set authorized-minters minter true)
    (ok true)))

;; Revoke minter authorization (only contract owner)
(define-public (revoke-minter (minter principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-delete authorized-minters minter)
    (ok true)))

;; Check if account is authorized minter
(define-read-only (is-minter (account principal))
  (ok (is-authorized-minter account)))
