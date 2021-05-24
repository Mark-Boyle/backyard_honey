const button = document.getElementById('stripe-button');
const {sessionId, publicKey} = button.dataset
button.addEventListener('click', () => {
  const stripe = Stripe(publicKey);
  stripe.redirectToCheckout({sessionId: sessionId});
});