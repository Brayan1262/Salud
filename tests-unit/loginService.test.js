/**
 * @jest-environment node
 */
import { jest } from '@jest/globals';
import { iniciarSesion } from "../Salud/Controlador/C-Registrar-login/loginService.js";

// Simulamos Firestore
const firestoreFns = {
  collection: jest.fn(),
  query: jest.fn(),
  where: jest.fn(),
  getDocs: jest.fn()
};

describe("🧪 Pruebas unitarias de iniciarSesion()", () => {
  const db = {};

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it("CP-01: Falla si los campos están vacíos", async () => {
    const res = await iniciarSesion("", "", db, firestoreFns);
    expect(res.ok).toBe(false);
    expect(res.mensaje).toMatch(/obligatorios/i);
  });

  it("CP-02: Usuario no encontrado", async () => {
    firestoreFns.getDocs.mockResolvedValueOnce({ empty: true });
    const res = await iniciarSesion("usuario@ejemplo.com", "1234", db, firestoreFns);
    expect(res.ok).toBe(false);
    expect(res.mensaje).toMatch(/no encontrado/i);
  });

  it("CP-03: Contraseña incorrecta", async () => {
    firestoreFns.getDocs.mockResolvedValueOnce({
      empty: false,
      docs: [{ data: () => ({ password: "correcta" }) }]
    });

    const res = await iniciarSesion("usuario@ejemplo.com", "mala", db, firestoreFns);
    expect(res.ok).toBe(false);
    expect(res.mensaje).toMatch(/contraseña incorrecta/i);
  });

  it("CP-04: Inicio de sesión exitoso", async () => {
    firestoreFns.getDocs.mockResolvedValueOnce({
      empty: false,
      docs: [{ data: () => ({ password: "1234" }) }]
    });

    const res = await iniciarSesion("usuario@ejemplo.com", "1234", db, firestoreFns);
    expect(res.ok).toBe(true);
    expect(res.mensaje).toMatch(/exitoso/i);
  });
});
