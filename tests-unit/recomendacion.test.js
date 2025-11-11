/**
 * @jest-environment jsdom
 */

import { handleRecomendacionMode } from '../Salud/Controlador/C-asistente-ia/alissa-smart-copy.js';

// Simulamos un contexto vacío
const fakeContext = { personalData: null };

describe('🧪 Recomendaciones de menú - Alissa', () => {

    test('CP-07: Generar recomendación básica', () => {
        const respuesta = handleRecomendacionMode("quiero una recomendación para el desayuno", fakeContext);
        expect(respuesta).toContain("🍳");
        expect(respuesta.toLowerCase()).toContain("desayuno");
    });

    test('CP-08: Actualizar recomendación con nuevos hábitos', () => {
        const contextConDatos = { personalData: { imc: 22.5, imcCategory: 'Peso normal' } };
        const respuesta = handleRecomendacionMode("he cambiado mis hábitos y quiero nueva recomendación", contextConDatos);
        
        // Ahora validamos por significado
        expect(respuesta).toMatch(/actualizado|nuevo menú|hábitos/i);
        expect(respuesta).toContain("🔄"); // símbolo de actualización
    });

    test('CP-09: Validar menús sin datos suficientes', () => {
        const respuesta = handleRecomendacionMode("no tengo datos", fakeContext);
        
        // Valida que se informe al usuario sobre completar la evaluación
        expect(respuesta).toMatch(/complete|evaluación|personalizadas/i);
        expect(respuesta).toContain("⚠️"); // símbolo de advertencia
    });
});
