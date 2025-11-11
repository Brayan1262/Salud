import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 20,          // 20 usuarios concurrentes
  duration: '30s',  // prueba durante 30 segundos
  thresholds: {
    http_req_duration: ['p(95)<2000'], // 95% < 2 segundos
    http_req_failed: ['rate<0.05'],    // <5% fallos
  },
};

const BASE_URL = 'http://127.0.0.1:8080/Salud/Vista/asistente-ia/asistente-ia.html';

export default function () {
  const res = http.get(BASE_URL);

  check(res, {
    '✅ Página carga correctamente (200)': (r) => r.status === 200,
    '📄 Contiene texto de bienvenida': (r) =>
      r.body.includes('Alissa') || r.body.includes('evaluar tus hábitos'),
  });

  // Simula que el usuario espera 1 seg antes de siguiente carga
  sleep(1);
}
