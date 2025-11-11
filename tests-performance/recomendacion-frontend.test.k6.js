import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 20,          // 20 usuarios concurrentes
  duration: '30s',  // duración total de la prueba
  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95% de respuestas <2s
    http_req_failed: ['rate<0.05'],    // <5% fallos
  },
};

// 🧠 URL del frontend
const BASE_URL = 'http://127.0.0.1:8080/Salud/Vista/asistente-ia/asistente-ia.html';

export default function () {
  const res = http.get(BASE_URL);

  check(res, {
    '✅ Página carga correctamente (200)': (r) => r.status === 200,
    '📄 Contiene texto de bienvenida de Alissa': (r) =>
      r.body.includes('Alissa') || r.body.includes('recomendación') || r.body.includes('menú'),
  });

  // ⏳ Simula tiempo de permanencia en la página
  sleep(1);
}
