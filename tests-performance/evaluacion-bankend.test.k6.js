import http from 'k6/http';
import { check, sleep } from 'k6';

// 🔧 Configuración de prueba
export const options = {
  vus: 10,            // usuarios concurrentes
  duration: '30s',    // duración total de la prueba
  thresholds: {
    http_req_duration: ['p(95)<1500'], // 95% de las peticiones deben responder <1.5s
    http_req_failed: ['rate<0.05'],    // <5% de errores aceptables
  },
};

const BASE_URL = 'http://127.0.0.1:5000/chat'; // Tu endpoint Flask

export default function () {
  // Simulación del flujo completo de conversación
  const mensajes = [
    'Hola, quiero evaluar mis hábitos alimenticios',
    'Como mucha comida chatarra',
    'Duermo poco y casi no tomo agua',
    'Ya terminé la evaluación',
  ];

  for (const mensaje of mensajes) {
    const res = http.post(
      BASE_URL,
      JSON.stringify({ message: mensaje }),
      { headers: { 'Content-Type': 'application/json' } }
    );

    check(res, {
      '✅ Respuesta exitosa (status 200)': (r) => r.status === 200,
      '💬 Contiene texto generado': (r) =>
        r.body && (r.body.includes('reply') || r.body.includes('🤖')),
    });

    // Simulamos el tiempo entre mensajes (1 seg)
    sleep(1);
  }
}
