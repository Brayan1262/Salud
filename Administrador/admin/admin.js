// JavaScript para la interfaz de administrador
document.addEventListener('DOMContentLoaded', function() {
    // Navegación entre secciones
    const menuItems = document.querySelectorAll('.menu-item');
    const contentSections = document.querySelectorAll('.content-section');
    const sectionTitle = document.getElementById('section-title');

    menuItems.forEach(item => {
        item.addEventListener('click', function() {
            const targetSection = this.getAttribute('data-section');
            
            // Actualizar menú activo
            menuItems.forEach(i => i.classList.remove('active'));
            this.classList.add('active');
            
            // Mostrar sección correspondiente
            contentSections.forEach(section => {
                section.classList.remove('active-section');
                if (section.id === targetSection) {
                    section.classList.add('active-section');
                }
            });
            
            // Actualizar título
            sectionTitle.textContent = this.querySelector('span').textContent;
        });
    });

    // Modal para agregar menú
    const addMenuBtn = document.getElementById('add-menu-btn');
    const menuModal = document.getElementById('menu-modal');
    const closeModalBtns = document.querySelectorAll('.close-btn, .close-modal');
    const menuForm = document.getElementById('menu-form');

    if (addMenuBtn) {
        addMenuBtn.addEventListener('click', function() {
            menuModal.style.display = 'flex';
        });
    }

    closeModalBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            menuModal.style.display = 'none';
        });
    });

    // Cerrar modal al hacer clic fuera del contenido
    window.addEventListener('click', function(event) {
        if (event.target === menuModal) {
            menuModal.style.display = 'none';
        }
    });

    // Manejar envío del formulario de menú
    if (menuForm) {
        menuForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Aquí iría la lógica para guardar el menú
            const menuName = document.getElementById('menu-name').value;
            alert(`Menú "${menuName}" agregado correctamente`);
            
            // Cerrar modal y resetear formulario
            menuModal.style.display = 'none';
            menuForm.reset();
        });
    }

    // Botones de acción en tablas
    const editButtons = document.querySelectorAll('.edit-btn');
    const deleteButtons = document.querySelectorAll('.delete-btn');

    editButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            // Aquí iría la lógica para editar
            alert('Funcionalidad de edición - En desarrollo');
        });
    });

    deleteButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            if (confirm('¿Está seguro de que desea eliminar este elemento?')) {
                // Aquí iría la lógica para eliminar
                const row = this.closest('tr');
                row.style.opacity = '0.5';
                setTimeout(() => {
                    row.remove();
                }, 300);
            }
        });
    });

    // Cerrar sesión
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function() {
            if (confirm('¿Está seguro de que desea cerrar sesión?')) {
                alert('Sesión cerrada - Redirigiendo al login');
                // Aquí iría la redirección al login
                // window.location.href = 'login.html';
            }
        });
    }

    // Actualizar predicción
    const updatePredictionBtn = document.getElementById('update-prediction');
    if (updatePredictionBtn) {
        updatePredictionBtn.addEventListener('click', function() {
            this.disabled = true;
            this.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Actualizando...';
            
            // Simular actualización
            setTimeout(() => {
                this.disabled = false;
                this.innerHTML = '<i class="fas fa-sync-alt"></i> Actualizar';
                alert('Predicción actualizada correctamente');
            }, 2000);
        });
    }

    // Simular gráficos (en un proyecto real usarías Chart.js o similar)
    function initializeCharts() {
        const chartPlaceholders = document.querySelectorAll('.chart-placeholder');
        chartPlaceholders.forEach(placeholder => {
            placeholder.innerHTML = '<div class="text-center"><i class="fas fa-chart-bar fa-2x mb-10" style="color: #2c7873;"></i><p>Gráfico interactivo</p><small>Usar Chart.js para visualizaciones reales</small></div>';
        });
    }

    initializeCharts();

    // Filtros de reportes
    const reportPeriod = document.getElementById('report-period');
    if (reportPeriod) {
        reportPeriod.addEventListener('change', function() {
            alert(`Reportes actualizados para: ${this.options[this.selectedIndex].text}`);
        });
    }

    // Manejo de switches de configuración
    const switches = document.querySelectorAll('.switch input');
    switches.forEach(switchInput => {
        switchInput.addEventListener('change', function() {
            const setting = this.closest('.switch').textContent.trim();
            const status = this.checked ? 'activada' : 'desactivada';
            console.log(`Configuración "${setting}" ${status}`);
        });
    });

    // Simular datos de estadísticas (actualización en tiempo real)
    function updateStats() {
        const statNumbers = document.querySelectorAll('.stat-info h3');
        statNumbers.forEach(stat => {
            const currentValue = parseInt(stat.textContent);
            if (!isNaN(currentValue)) {
                // Simular pequeñas variaciones
                const variation = Math.floor(Math.random() * 10) - 2; // -2 a +7
                const newValue = Math.max(0, currentValue + variation);
                stat.textContent = newValue.toLocaleString();
            }
        });
    }

    // Actualizar estadísticas cada 30 segundos
    setInterval(updateStats, 30000);
});