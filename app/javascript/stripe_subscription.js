document.addEventListener("turbo:load", function() {
  var form = document.getElementById("subscription-form");
  if (!form) return;
  if (window.stripeCardElement) {
    window.stripeCardElement.unmount();
    window.stripeCardElement = null;
  }
  var stripe = Stripe(document.querySelector('meta[name="stripe-publishable-key"]').content);
  var elements = stripe.elements();
  var card = elements.create("card", { hidePostalCode: true });
  card.mount("#card-element");
  window.stripeCardElement = card;

  form.addEventListener("submit", function(event) {
    event.preventDefault();
    stripe.createPaymentMethod({
      type: 'card',
      card: card,
    }).then(function(result) {
      if (result.error) {
        document.getElementById("card-errors").textContent = result.error.message;
      } else {
        var hiddenInput = document.createElement('input');
        hiddenInput.setAttribute('type', 'hidden');
        hiddenInput.setAttribute('name', 'payment_method_id');
        hiddenInput.setAttribute('value', result.paymentMethod.id);
        form.appendChild(hiddenInput);
        form.submit();
      }
    });
  });
});
