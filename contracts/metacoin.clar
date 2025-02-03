;; MetaCoin - Currency for the VR asset marketplace
(define-fungible-token metacoin)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-balance (err u101))

(define-data-var token-uri (string-utf8 256) "https://metacoin.vr/token")

;; Mint new tokens (owner only)
(define-public (mint (amount uint) (recipient principal))
  (if (is-eq tx-sender contract-owner)
    (ft-mint? metacoin amount recipient)
    err-owner-only))

;; Transfer tokens
(define-public (transfer (amount uint) (recipient principal))
  (ft-transfer? metacoin amount tx-sender recipient))

;; Get balance
(define-read-only (get-balance (account principal))
  (ok (ft-get-balance metacoin account)))
