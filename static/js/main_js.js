// -------------------- CARRITO --------------------

document.addEventListener('DOMContentLoaded', () => {
    console.log("DOM cargado - inicializando carrito");
    actualizarContadorCarrito();
    registrarEventosBotonesCarrito();
    
    // Si estamos en la página del carrito, actualizamos la tabla
    if (document.getElementById('tabla-carrito')) {
        actualizarTablaCarrito();
    }
});

function registrarEventosBotonesCarrito() {
    console.log("Registrando eventos para botones del carrito");
    
    // Usamos ambos selectores para asegurar que todos los botones funcionen
    document.querySelectorAll('.btn-add-cart, .añadir-carrito').forEach(boton => {
        console.log("Botón encontrado:", boton.dataset.id, boton.dataset.nombre);
        
        // En lugar de removeEventListener (que puede no funcionar correctamente),
        // usamos un flag para evitar duplicados
        if (!boton.hasAttribute('data-event-registered')) {
            boton.addEventListener('click', handleAgregarAlCarrito);
            boton.setAttribute('data-event-registered', 'true');
            console.log("Evento registrado para:", boton.dataset.nombre);
        }
    });
}

function handleAgregarAlCarrito(event) {
    event.preventDefault();
    console.log("Evento de añadir al carrito activado");
    
    const btn = event.currentTarget;
    const id = btn.dataset.id;
    const nombre = btn.dataset.nombre;
    const precio = parseFloat(btn.dataset.precio);

    console.log("Datos del producto:", { id, nombre, precio });

    if (!id || !nombre || isNaN(precio)) {
        console.warn("Datos del producto incompletos o incorrectos:", { id, nombre, precio });
        return;
    }

    let carrito = [];
    try {
        const carritoGuardado = localStorage.getItem('carrito');
        console.log("Carrito recuperado:", carritoGuardado);
        
        if (carritoGuardado) {
            carrito = JSON.parse(carritoGuardado);
            if (!Array.isArray(carrito)) {
                console.warn("El carrito no es un array, se inicializará uno nuevo");
                carrito = [];
            }
        }
    } catch (e) {
        console.error("Error al leer el carrito:", e);
        carrito = [];
    }

    // Obtener cantidad (1 por defecto, o desde un input si existe)
    let cantidad = 1;
    const inputCantidad = document.getElementById('cantidad');
    if (inputCantidad && !isNaN(parseInt(inputCantidad.value))) {
        cantidad = parseInt(inputCantidad.value);
    }

    console.log("Cantidad a añadir:", cantidad);

    const existente = carrito.find(p => p.id === id);
    if (existente) {
        existente.cantidad += cantidad;
        console.log("Producto existente actualizado:", existente);
    } else {
        carrito.push({ id, nombre, precio, cantidad });
        console.log("Nuevo producto añadido:", { id, nombre, precio, cantidad });
    }

    try {
        localStorage.setItem('carrito', JSON.stringify(carrito));
        console.log("Carrito guardado en localStorage:", carrito);
        actualizarContadorCarrito();
        
        // Disparar evento personalizado para notificar a otras partes de la aplicación
        const eventoCarritoActualizado = new Event('carritoActualizado');
        window.dispatchEvent(eventoCarritoActualizado);
        
        // Mostrar mensaje de confirmación
        if (typeof toastr !== 'undefined') {
            toastr.success(`${cantidad} unidad(es) de ${nombre} añadidas al carrito`);
        } else {
            alert(`${cantidad} unidad(es) de ${nombre} añadidas al carrito`);
        }
    } catch (e) {
        console.error("Error al guardar el carrito:", e);
    }
}

function actualizarContadorCarrito() {
    console.log("Actualizando contador del carrito");
    
    try {
        const carritoGuardado = localStorage.getItem('carrito');
        let total = 0;
        
        if (carritoGuardado) {
            const carrito = JSON.parse(carritoGuardado);
            if (Array.isArray(carrito)) {
                total = carrito.reduce((acc, item) => acc + (item.cantidad || 0), 0);
            }
        }
        
        const contador = document.getElementById('carrito-contador');
        if (contador) {
            contador.textContent = total.toString();
            console.log("Contador actualizado:", total);
        }
    } catch (e) {
        console.error("Error al actualizar contador:", e);
    }
}

// -------------------- FUNCIONES AUXILIARES PARA /ventas/crear --------------------

function actualizarTablaCarrito() {
    console.log("Actualizando tabla del carrito");
    
    const tablaBody = document.querySelector('#tabla-carrito tbody');
    if (!tablaBody) {
        console.warn("No se encontró la tabla del carrito");
        return;
    }
    
    const totalElemento = document.querySelector('#tabla-carrito tfoot td.text-end');
    const btnFinalizarCompra = document.getElementById('finalizar-compra');
    
    // Buscar o crear el input hidden para el formulario
    let inputHidden = document.querySelector('input[name="carrito_datos"]');
    if (!inputHidden) {
        inputHidden = document.createElement('input');
        inputHidden.type = 'hidden';
        inputHidden.name = 'carrito_datos';
        
        const form = document.querySelector('form[action*="crear_venta"]');
        if (form) {
            form.appendChild(inputHidden);
        } else {
            console.warn("No se encontró un formulario para añadir el input hidden");
        }
    }

    let carrito;
    try {
        const carritoGuardado = localStorage.getItem('carrito');
        carrito = carritoGuardado ? JSON.parse(carritoGuardado) : [];
        
        if (!Array.isArray(carrito)) {
            console.warn("El carrito recuperado no es un array, se inicializará uno nuevo");
            carrito = [];
            localStorage.setItem('carrito', JSON.stringify(carrito));
        }
    } catch (e) {
        console.error("Error al leer el carrito:", e);
        localStorage.removeItem('carrito');
        carrito = [];
    }

    console.log("Contenido del carrito para la tabla:", carrito);

    if (carrito.length === 0) {
        tablaBody.innerHTML = '<tr><td colspan="5" class="text-center text-muted">El carrito está vacío.</td></tr>';
        if (totalElemento) totalElemento.textContent = '0.00 €';
        if (inputHidden) inputHidden.value = JSON.stringify([]);
        
        // Deshabilitar botón de finalizar compra
        if (btnFinalizarCompra) btnFinalizarCompra.disabled = true;
        
        return;
    }

    // Limpiar tabla
    tablaBody.innerHTML = '';
    
    // Calcular total y generar filas
    let total = 0;

    carrito.forEach((item, index) => {
        const subtotal = item.precio * item.cantidad;
        total += subtotal;

        const fila = document.createElement('tr');
        fila.innerHTML = `
            <td>${item.nombre}</td>
            <td class="text-end">${item.precio.toFixed(2)} €</td>
            <td class="text-center">
                <div class="input-group input-group-sm">
                    <button type="button" class="btn btn-outline-secondary btn-decrease" data-index="${index}">-</button>
                    <input type="number" class="form-control text-center input-cantidad" value="${item.cantidad}" min="1" max="99" data-index="${index}">
                    <button type="button" class="btn btn-outline-secondary btn-increase" data-index="${index}">+</button>
                </div>
            </td>
            <td class="text-end">${subtotal.toFixed(2)} €</td>
            <td class="text-center">
                <button type="button" class="btn btn-sm btn-danger eliminar-producto" data-index="${index}">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </td>
        `;
        tablaBody.appendChild(fila);
    });

    // Actualizar total
    if (totalElemento) totalElemento.textContent = total.toFixed(2) + ' €';
    
    // Actualizar input hidden
    if (inputHidden) inputHidden.value = JSON.stringify(carrito);
    
    // Habilitar botón de finalizar compra
    if (btnFinalizarCompra) btnFinalizarCompra.disabled = false;

    // Registrar eventos para botones de controles de cantidad y eliminar
    registrarEventosControlesCarrito(carrito);
}

function registrarEventosControlesCarrito(carrito) {
    // Añadir eventos a los botones de eliminar
    document.querySelectorAll('.eliminar-producto').forEach(boton => {
        boton.addEventListener('click', () => {
            const index = parseInt(boton.dataset.index);
            
            if (!isNaN(index) && index >= 0 && index < carrito.length) {
                console.log("Eliminando producto:", carrito[index].nombre);
                carrito.splice(index, 1);
                localStorage.setItem('carrito', JSON.stringify(carrito));
                
                // Actualizar UI
                actualizarContadorCarrito();
                actualizarTablaCarrito();
                
                // Mostrar notificación
                if (typeof toastr !== 'undefined') {
                    toastr.success('Producto eliminado del carrito');
                }
            }
        });
    });
    
    // Añadir eventos a los botones de decrementar cantidad
    document.querySelectorAll('.btn-decrease').forEach(boton => {
        boton.addEventListener('click', () => {
            const index = parseInt(boton.dataset.index);
            if (isNaN(index) || index < 0 || index >= carrito.length) return;
            
            if (carrito[index].cantidad > 1) {
                carrito[index].cantidad -= 1;
                localStorage.setItem('carrito', JSON.stringify(carrito));
                actualizarContadorCarrito();
                actualizarTablaCarrito();
            }
        });
    });
    
    // Añadir eventos a los botones de incrementar cantidad
    document.querySelectorAll('.btn-increase').forEach(boton => {
        boton.addEventListener('click', () => {
            const index = parseInt(boton.dataset.index);
            if (isNaN(index) || index < 0 || index >= carrito.length) return;
            
            carrito[index].cantidad += 1;
            localStorage.setItem('carrito', JSON.stringify(carrito));
            actualizarContadorCarrito();
            actualizarTablaCarrito();
        });
    });
    
    // Añadir eventos a los inputs de cantidad
    document.querySelectorAll('.input-cantidad').forEach(input => {
        input.addEventListener('change', () => {
            const index = parseInt(input.dataset.index);
            if (isNaN(index) || index < 0 || index >= carrito.length) return;
            
            const cantidad = parseInt(input.value);
            if (isNaN(cantidad) || cantidad < 1) {
                input.value = carrito[index].cantidad;
                return;
            }
            
            carrito[index].cantidad = cantidad;
            localStorage.setItem('carrito', JSON.stringify(carrito));
            actualizarContadorCarrito();
            actualizarTablaCarrito();
        });
    });
}

// Función para vaciar el carrito
function vaciarCarrito() {
    console.log("Vaciando carrito");
    localStorage.removeItem('carrito');
    actualizarContadorCarrito();
    
    // Disparar evento personalizado
    const eventoCarritoActualizado = new Event('carritoActualizado');
    window.dispatchEvent(eventoCarritoActualizado);
    
    if (document.getElementById('tabla-carrito')) {
        actualizarTablaCarrito();
    } else {
        location.reload(); // Si no estamos en la página del carrito, recargamos
    }
    
    // Mostrar notificación
    if (typeof toastr !== 'undefined') {
        toastr.success('Carrito vaciado correctamente');
    }
}