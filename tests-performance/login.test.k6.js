import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 5,          // usuarios simultáneos
  duration: '10s', // duración total
};

const BASE_URL = 'http://127.0.0.1:8080/Salud/Vista/Registrar-login';

export default function () {

  // 🧪 CP-01: Carga la página de login (campos vacíos)
  const resPage = http.get(`${BASE_URL}/register-login.html?mode=login`);
  check(resPage, {
    '⚙️ CP-01: carga exitosa del login HTML': (r) => r.status === 200,
    '⚠️ CP-01: HTML contiene formulario de login': (r) =>
      r.body.includes('loginSubmit') || r.body.includes('email'),
  });

  // 🧪 CP-02: Simular inicio de sesión exitoso (mock)
  const loginData = {
    email: 'bchavezos@ucvvirtual.edu.pe',
    password: 'contraseña',
  };

  const resLogin = http.post(
    `${BASE_URL}/register-login.html?mode=login`,
    JSON.stringify(loginData),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );

  check(resLogin, {
    '✅ CP-02: solicitud de login enviada': (r) => r.status === 200,
  });

  // 🧪 CP-03: Simular intento fallido
  const badLogin = {
    email: 'usuario@ejemplo.com',
    password: 'incorrecta',
  };

  const resFail = http.post(
    `${BASE_URL}/register-login.html?mode=login`,
    JSON.stringify(badLogin),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );

  check(resFail, {
    '❌ CP-03: solicitud con credenciales incorrectas enviada': (r) =>
      r.status === 200,
  });

  sleep(1);
}
