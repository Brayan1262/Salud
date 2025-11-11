import http from 'k6/http';
import { check, sleep } from 'k6';

// 🔧 Configuración
export const options = {
  vus: 10,            // usuarios concurrentes
  duration: '30s',    // duración total
  thresholds: {
    http_req_duration: ['p(95)<1500'], // 95% <1.5s
    http_req_failed: ['rate<0.05'],    // <5% errores
  },
};

const BASE_URL = 'http://127.0.0.1:5000/chat'; // Endpoint Flask

export default function () {
  // Mensajes simulados del modo recomendación
  const mensajes = [
    'Quiero una recomendación para el desayuno',
    'He cambiado mis hábitos y quiero nueva recomendación',
    'No tengo datos todavía',
  ];

  for (const mensaje of mensajes) {
    const res = http.post(
      BASE_URL,
      JSON.stringify({ message: mensaje }),
      { headers: { 'Content-Type': 'application/json' } }
    );

    check(res, {
      '✅ Respuesta exitosa (status 200)': (r) => r.status === 200,
      '💬 Contiene respuesta válida': (r) =>
        r.body &&
        (r.body.includes('reply') ||
         r.body.includes('recomendación') ||
         r.body.includes('Complete su evaluación')),
    });

    sleep(1); // espera 1s entre mensajes
  }
}
