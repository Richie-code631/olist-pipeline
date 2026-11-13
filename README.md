## Data quality findings

1. **Duplicate order IDs.** The check found 0 duplicates, so `order_id` is the primary key of orders.
2. **Orphan order items.** The check found 0 order items without a matching order, so joins between order items and orders are safe.
3. **Delivered before purchased.** The check found 0 orders with a delivery date earlier than the purchase date, so no timestamp corrections are needed.
4. **Delivered orders with no delivery date.** The check found 8 of 96,478 delivered orders with no delivery date. Decision: keep them in `core` and add a flag column (`delivery_date_missing`), so revenue totals stay complete and delivery-time reports can exclude them.
5. **Canceled orders with a delivery date.** The check found 6 of 625 canceled orders with a delivery date. The data doesn't explain why, so they are kept as they are and noted for review.