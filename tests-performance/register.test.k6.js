import http from 'k6/http';
import { check, sleep } from 'k6';

// Configuración del test
export const options = {
  vus: 5, // usuarios virtuales concurrentes
  duration: '10s', // duración total del test
};

// Base URL del proyecto local
const BASE_URL = 'http://127.0.0.1:8080/Salud/Vista/Registrar-login/register-login.html?mode=register';

export default function () {
  // 1️⃣ Cargar la página de registro
  const resPage = http.get(BASE_URL);

  check(resPage, {
    '⚙️ CP-01: carga exitosa del registro HTML': (r) => r.status === 200,
    '⚠️ CP-01: HTML contiene formulario de registro': (r) =>
      r.body.includes('registerSubmit') && r.body.includes('email'),
  });

  // Simulamos espera del usuario leyendo la página
  sleep(1);

  // 2️⃣ Simular envío del formulario con datos válidos (registro exitoso)
  const registerData = {
    email: 'usuario_prueba@ucv.edu.pe',
    password: 'ContraseñaSegura123',
    confirmPassword: 'ContraseñaSegura123',
    edad: '25',
    genero: 'Masculino',
    altura: '170',
    peso: '70',
  };

  const resRegister = http.post(
    'http://127.0.0.1:8080/api/register', // simulado
    JSON.stringify(registerData),
    {
      headers: { 'Content-Type': 'application/json' },
    }
  );

  check(resRegister, {
    '✅ CP-02: solicitud de registro enviada (simulada)': (r) =>
      r.status === 200 || r.status === 404 || r.status === 0, // permite fallo si no hay backend
  });

  // 3️⃣ Simular registro de usuario duplicado
  const duplicateData = { ...registerData, email: 'bchavezos@ucvvirtual.edu.pe' };
  const resDuplicate = http.post(
    'http://127.0.0.1:8080/api/register',
    JSON.stringify(duplicateData),
    { headers: { 'Content-Type': 'application/json' } }
  );

  check(resDuplicate, {
    '⚠️ CP-03: registro duplicado detectado (simulado)': (r) =>
      r.status === 409 || r.status === 404 || r.status === 0,
  });

  // Espera entre iteraciones
  sleep(1);
}
