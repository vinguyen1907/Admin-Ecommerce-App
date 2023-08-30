enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
  returned,
  refunded,
  onHold,
  outForDelivery,
  failedDelivery,
}

final Map<OrderStatus, String> orderStatusName = {
  OrderStatus.pending: "Pending",
  OrderStatus.processing: "Processing",
  OrderStatus.shipped: "Shipped",
  OrderStatus.delivered: "Delivered",
  OrderStatus.cancelled: "Cancelled",
  OrderStatus.returned: "Returned",
  OrderStatus.refunded: "Refunded",
  OrderStatus.onHold: "On hold",
  OrderStatus.outForDelivery: "Out for delivery",
  OrderStatus.failedDelivery: "Failed delivery",
};

final Map<OrderStatus, String> orderStatusToString = {
  OrderStatus.pending: "pending",
  OrderStatus.processing: "processing",
  OrderStatus.shipped: "shipped",
  OrderStatus.delivered: "delivered",
  OrderStatus.cancelled: "cancelled",
  OrderStatus.returned: "returned",
  OrderStatus.refunded: "refunded",
  OrderStatus.onHold: "on_hold",
  OrderStatus.outForDelivery: "out_for_delivery",
  OrderStatus.failedDelivery: "failed_delivery",
};

final Map<String, OrderStatus> stringToOrderStatus = {
  "pending": OrderStatus.pending,
  "processing": OrderStatus.processing,
  "shipped": OrderStatus.shipped,
  "delivered": OrderStatus.delivered,
  "cancelled": OrderStatus.cancelled,
  "returned": OrderStatus.returned,
  "refunded": OrderStatus.refunded,
  "on_hold": OrderStatus.onHold,
  "out_for_delivery": OrderStatus.outForDelivery,
  "failed_delivery": OrderStatus.failedDelivery,
};

final Map<OrderStatus, String> trackingStatusTitle = {
  OrderStatus.pending: "Your order is sent to seller",
  OrderStatus.processing: "Being processed",
  OrderStatus.shipped: "In the transit way",
  OrderStatus.delivered: "Successfully delivered",
  OrderStatus.cancelled: "Cancelled",
  OrderStatus.returned: "Returned to the seller or the fulfillment center",
  OrderStatus.refunded: "Received refund",
  OrderStatus.onHold: "On hold",
  OrderStatus.outForDelivery: "Out for delivery",
  OrderStatus.failedDelivery: "Delivered unsuccessful",
};
//   "Not Shipped": The order has not been shipped yet.
// "In Transit": The order is currently in transit and on its way to the customer.
// "Out for Delivery": The order is out for delivery and will be delivered to the customer soon.
// "Delivered": The order has been successfully delivered to the customer.
// "Failed Delivery": The delivery attempt was unsuccessful, and the order needs to be rescheduled or reattempted.
// "Returned": The order was returned to the seller or the fulfillment center.