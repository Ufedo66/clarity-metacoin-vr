;; VR Asset NFT Contract
(define-non-fungible-token vr-asset uint)

(define-map asset-metadata
  uint
  {
    name: (string-utf8 64),
    description: (string-utf8 256),
    image-uri: (string-utf8 256),
    creator: principal,
    royalty-percent: uint
  })

(define-data-var last-token-id uint u0)

;; Mint new VR asset
(define-public (mint-asset (name (string-utf8 64)) 
                          (description (string-utf8 256))
                          (image-uri (string-utf8 256))
                          (royalty-percent uint))
  (let ((token-id (+ (var-get last-token-id) u1)))
    (try! (nft-mint? vr-asset token-id tx-sender))
    (map-set asset-metadata token-id
      {
        name: name,
        description: description,
        image-uri: image-uri,
        creator: tx-sender,
        royalty-percent: royalty-percent
      })
    (var-set last-token-id token-id)
    (ok token-id)))

;; Transfer asset
(define-public (transfer-asset (token-id uint) (recipient principal))
  (nft-transfer? vr-asset token-id tx-sender recipient))
