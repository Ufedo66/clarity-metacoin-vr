;; Marketplace for VR Assets
(use-trait metacoin-trait .metacoin.metacoin-trait)
(use-trait vr-asset-trait .vr-asset.vr-asset-trait)

(define-map listings
  uint
  {
    seller: principal,
    price: uint
  })

;; List asset for sale
(define-public (list-asset (token-id uint) (price uint))
  (let ((owner (unwrap! (nft-get-owner? vr-asset token-id) (err u404))))
    (asserts! (is-eq tx-sender owner) (err u403))
    (map-set listings token-id {seller: tx-sender, price: price})
    (ok true)))

;; Buy listed asset
(define-public (buy-asset (token-id uint))
  (let ((listing (unwrap! (map-get? listings token-id) (err u404)))
        (price (get price listing))
        (seller (get seller listing)))
    ;; Transfer payment
    (try! (contract-call? .metacoin transfer price seller))
    ;; Transfer asset
    (try! (contract-call? .vr-asset transfer-asset token-id tx-sender))
    ;; Delete listing
    (map-delete listings token-id)
    (ok true)))
