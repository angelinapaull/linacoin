(define-trait sip-010-ft-trait
  (
    (get-name () (response (string-ascii 32) uint))
    (get-symbol () (response (string-ascii 32) uint))
    (get-decimals () (response uint uint))
    (get-total-supply () (response uint uint))
    (get-balance (principal) (response uint uint))
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
    (approve (principal uint) (response bool uint))
    (allowance (principal principal) (response uint uint))
  )
)