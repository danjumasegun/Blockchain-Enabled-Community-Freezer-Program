;; Facility Registration Contract
;; Records details of shared food storage locations

(define-data-var last-id uint u0)

(define-map facilities
  { id: uint }
  {
    name: (string-ascii 100),
    location: (string-ascii 100),
    capacity: uint,
    active: bool,
    manager: principal
  }
)

;; Register a facility
(define-public (register
    (name (string-ascii 100))
    (location (string-ascii 100))
    (capacity uint)
  )
  (let
    (
      (new-id (+ (var-get last-id) u1))
    )
    (var-set last-id new-id)

    (map-set facilities
      { id: new-id }
      {
        name: name,
        location: location,
        capacity: capacity,
        active: true,
        manager: tx-sender
      }
    )

    (ok new-id)
  )
)

;; Update facility status
(define-public (update-status
    (facility-id uint)
    (active bool)
  )
  (let
    (
      (facility (unwrap! (map-get? facilities { id: facility-id }) (err u404)))
    )
    (asserts! (is-eq tx-sender (get manager facility)) (err u403))

    (map-set facilities
      { id: facility-id }
      (merge facility { active: active })
    )

    (ok true)
  )
)

;; Get facility
(define-read-only (get-facility (id uint))
  (map-get? facilities { id: id })
)

;; Get facility count
(define-read-only (get-count)
  (var-get last-id)
)

