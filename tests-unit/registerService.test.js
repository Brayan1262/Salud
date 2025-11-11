import { jest } from '@jest/globals';
import { registrarUsuario } from '../Salud/Controlador/C-Registrar-login/registerService.js';

const mockCollection = jest.fn();
const mockQuery = jest.fn();
const mockWhere = jest.fn();
const mockGetDocs = jest.fn();
const mockDoc = jest.fn();
const mockSetDoc = jest.fn();

const firestoreMocks = {
    collection: mockCollection,
    query: mockQuery,
    where: mockWhere,
    getDocs: mockGetDocs,
    doc: mockDoc,
    setDoc: mockSetDoc
};

describe('🧪 Pruebas unitarias de registrarUsuario()', () => {

    const db = {}; // simulación

    beforeEach(() => {
        jest.clearAllMocks();
    });

    test('CP-01: Falla si faltan campos obligatorios', async () => {
        const datos = { email: '', password: '', confirmPassword: '', edad: '', genero: '', altura: '', peso: '' };
        const resultado = await registrarUsuario(datos, db, firestoreMocks);
        expect(resultado).toEqual({ ok: false, mensaje: "⚠️ Todos los campos son obligatorios." });
    });

    test('CP-02: Registro exitoso', async () => {
        mockGetDocs.mockResolvedValueOnce({ empty: true });
        mockSetDoc.mockResolvedValueOnce(true);

        const datos = {
        email: 'nuevo@gmail.com',
        password: 'Segura123',
        confirmPassword: 'Segura123',
        edad: '25', genero: 'Masculino', altura: '170', peso: '70'
        };

        const resultado = await registrarUsuario(datos, db, firestoreMocks);
        expect(resultado).toEqual({ ok: true, mensaje: "✅ Registro guardado correctamente" });
    });

    test('CP-03: Usuario duplicado', async () => {
        mockGetDocs.mockResolvedValueOnce({ empty: false });

        const datos = {
        email: 'repetido@gmail.com',
        password: 'Segura123',
        confirmPassword: 'Segura123',
        edad: '30', genero: 'Femenino', altura: '160', peso: '60'
        };

        const resultado = await registrarUsuario(datos, db, firestoreMocks);
        expect(resultado).toEqual({ ok: false, mensaje: "⚠️ Usuario ya registrado" });
    });

    test('Contraseñas no coinciden', async () => {
        const datos = {
        email: 'test@gmail.com',
        password: '1234',
        confirmPassword: '5678',
        edad: '25', genero: 'Masculino', altura: '180', peso: '75'
        };

        const resultado = await registrarUsuario(datos, db, firestoreMocks);
        expect(resultado).toEqual({ ok: false, mensaje: "❌ Las contraseñas no coinciden" });
    });
});
