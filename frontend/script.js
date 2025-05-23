
document.getElementById('messageForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const message = document.getElementById('messageInput').value;

  const res = await fetch('http://localhost:5000/api/message', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ message })
  });

  const data = await res.json();
  document.getElementById('response').textContent = data.reply;
});
