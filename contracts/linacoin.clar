(impl-trait .sip-010-trait.sip-010-ft-trait)

(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)
(define-constant ERR-INSUFFICIENT-ALLOWANCE u102)
(define-constant ERR-OVERFLOW u103) ;; reserved; arithmetic overflows trap in Clarity
(define-constant ERR-ZERO-ADDRESS u104)

(define-constant TOKEN-NAME (some "linacoin"))
(define-constant TOKEN-SYMBOL (some "LINA"))
(define-constant TOKEN-DECIMALS u6)

(define-data-var total-supply uint u0)
(define-data-var owner principal tx-sender)

(define-map balances principal uint)
(define-map allowances { owner: principal, spender: principal } uint)

(define-read-only (get-owner)
  (ok (var-get owner)))

(define-read-only (get-name)
  (ok (default-to "" TOKEN-NAME)))

(define-read-only (get-symbol)
  (ok (default-to "" TOKEN-SYMBOL)))

(define-read-only (get-decimals)
  (ok TOKEN-DECIMALS))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-balance (who principal))
  (ok (default-to u0 (map-get? balances who))))

(define-private (is-owner (who principal))
  (is-eq who (var-get owner)))

(define-public (set-owner (new-owner principal))
  (begin
    (try! (if (not (is-owner tx-sender)) (err ERR-NOT-AUTHORIZED) (ok true)))
    (try! (if (is-eq new-owner 'SP000000000000000000002Q6VF78) (err ERR-ZERO-ADDRESS) (ok true)))
    (var-set owner new-owner)
    (ok true)))

(define-private (credit (to principal) (amount uint))
  (let ((current (default-to u0 (map-get? balances to))))
    (map-set balances to (+ current amount))
    true))

(define-private (debit (from principal) (amount uint))
  (let ((current (default-to u0 (map-get? balances from))))
    (if (>= current amount)
        (begin (map-set balances from (- current amount)) (ok true))
        (err ERR-INSUFFICIENT-BALANCE))))

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (let ((allow (default-to u0 (map-get? allowances { owner: sender, spender: tx-sender }))))
    (begin
      (try! (if (is-eq recipient 'SP000000000000000000002Q6VF78) (err ERR-ZERO-ADDRESS) (ok true)))
      (try! (if (not (or (is-eq sender tx-sender) (>= allow amount))) (err ERR-INSUFFICIENT-ALLOWANCE) (ok true)))
(match (debit sender amount)
        v1 (begin
             (credit recipient amount)
             (if (and (not (is-eq sender tx-sender)) (> amount u0))
                 (map-set allowances { owner: sender, spender: tx-sender } (- allow amount))
                 false)
             (ok true))
        e (err e)))))

(define-public (approve (spender principal) (amount uint))
  (begin
    (map-set allowances { owner: tx-sender, spender: spender } amount)
    (ok true)))

(define-read-only (allowance (own principal) (spndr principal))
  (ok (default-to u0 (map-get? allowances { owner: own, spender: spndr }))))

(define-public (mint (amount uint) (recipient principal))
  (begin
    (try! (if (not (is-owner tx-sender)) (err ERR-NOT-AUTHORIZED) (ok true)))
    (try! (if (is-eq recipient 'SP000000000000000000002Q6VF78) (err ERR-ZERO-ADDRESS) (ok true)))
    (credit recipient amount)
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok true)))

(define-public (burn (amount uint) (from principal))
  (begin
    (try! (if (not (is-owner tx-sender)) (err ERR-NOT-AUTHORIZED) (ok true)))
(match (debit from amount)
      v (begin (var-set total-supply (- (var-get total-supply) amount)) (ok true))
      e (err e))))
