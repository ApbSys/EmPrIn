"""
Módulo principal de la aplicación web Store Componentes.

Este módulo contiene la aplicación Flask y todas las rutas y vistas
para la gestión de la tienda de componentes informáticos.

"""

from flask import Flask, render_template, request, redirect, url_for, flash, session, jsonify
from models import Usuario, Proveedor, Producto, Venta, VentaDetalle, Compra, CompraDetalle, Estadisticas
from db import inicializar_db, get_db
import os
import datetime
from werkzeug.utils import secure_filename
import json

# ===================================================================
# CONFIGURACIÓN DE LA APLICACIÓN
# ===================================================================

# Inicializar la base de datos
inicializar_db()

# Configuración de la aplicación Flask
app = Flask(__name__)
app.secret_key = 'clave_secreta_store_componentes'  # Cambiar en producción
app.config['UPLOAD_FOLDER'] = os.path.join('static', 'uploads')
app.config['MAX_CONTENT_LENGTH'] = 2 * 1024 * 1024  # 2MB máximo

# Asegurar que existe el directorio de uploads
if not os.path.exists(app.config['UPLOAD_FOLDER']):
    os.makedirs(app.config['UPLOAD_FOLDER'])


# ===================================================================
# FILTROS TEMPLATE Y CONTEXTO GLOBAL
# ===================================================================

# Filtro Jinja2 para formatear fechas
@app.template_filter('datetime')
def format_datetime(value, format='%d/%m/%Y %H:%M'):
    """Formatea una fecha en el formato especificado."""
    if isinstance(value, str):
        try:
            value = datetime.datetime.fromisoformat(value)
        except ValueError:
            return value
    return value.strftime(format)


# Filtro Jinja2 para convertir saltos de línea en <br>
@app.template_filter('nl2br')
def nl2br(value):
    """Convierte saltos de línea en etiquetas HTML <br>."""
    if not value:
        return ''
    return value.replace('\n', '<br>')


# Contexto global para las plantillas
@app.context_processor
def inject_context():
    """Inyecta variables globales en todas las plantillas."""
    return {
        'now': datetime.datetime.now()
    }


# ===================================================================
# RUTAS DE AUTENTICACIÓN Y USUARIOS
# ===================================================================

@app.route('/login', methods=['GET', 'POST'])
def login():
    """
    Vista para el inicio de sesión de usuarios.

    GET: Muestra el formulario de login
    POST: Procesa el inicio de sesión
    """
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')

        usuario = Usuario.get_by_username(username)

        if usuario and Usuario.verify_password(usuario.password, password):
            # Guardar información del usuario en la sesión
            session['usuario_id'] = usuario.id
            session['username'] = usuario.username
            session['es_admin'] = usuario.es_admin

            flash('Sesión iniciada correctamente', 'success')
            return redirect(url_for('home'))
        else:
            flash('Nombre de usuario o contraseña incorrectos', 'danger')

    return render_template('login.html')


@app.route('/registro', methods=['GET', 'POST'])
def registro():
    """
    Vista para el registro de nuevos usuarios.

    GET: Muestra el formulario de registro
    POST: Procesa el registro de un nuevo usuario
    """
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')
        password_confirm = request.form.get('password_confirm')

        # Validaciones
        if not username or not email or not password:
            flash('Todos los campos son obligatorios', 'danger')
            return render_template('registro.html')

        if password != password_confirm:
            flash('Las contraseñas no coinciden', 'danger')
            return render_template('registro.html')

        if len(password) < 6:
            flash('La contraseña debe tener al menos 6 caracteres', 'danger')
            return render_template('registro.html')

        # Verificar si el usuario ya existe
        if Usuario.get_by_username(username):
            flash('El nombre de usuario ya está en uso', 'danger')
            return render_template('registro.html')

        # Crear el nuevo usuario
        nuevo_usuario = Usuario(
            username=username,
            email=email,
            password=Usuario.hash_password(password),
            es_admin=False
        )

        nuevo_usuario.save()

        flash('Cuenta creada correctamente. Ya puedes iniciar sesión.', 'success')
        return redirect(url_for('login'))

    return render_template('registro.html')


@app.route('/logout')
def logout():
    """
    Vista para cerrar la sesión del usuario.
    """
    session.clear()
    flash('Has cerrado sesión correctamente', 'success')
    return redirect(url_for('home'))


@app.route('/usuarios/gestionar', methods=['GET'])
def gestionar_usuarios():
    """
    Vista para gestionar usuarios (solo administradores).
    """
    if not session.get('es_admin'):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('home'))

    busqueda = request.args.get('busqueda', '').strip()

    if busqueda:
        usuarios = Usuario.buscar(busqueda)
    else:
        usuarios = []

    return render_template('usuarios/usuarios_listar.html', usuarios=usuarios, busqueda=busqueda)


@app.route('/usuarios/<int:usuario_id>/editar', methods=['GET', 'POST'])
def editar_usuario(usuario_id):
    """
    Vista para editar un usuario (solo administradores).
    
    Args:
        usuario_id (int): ID del usuario a editar
    """
    if not session.get('es_admin'):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('home'))

    usuario = Usuario.get_by_id(usuario_id)
    if not usuario:
        flash('Usuario no encontrado', 'danger')
        return redirect(url_for('gestionar_usuarios'))

    if request.method == 'POST':
        usuario.username = request.form.get('username')
        usuario.email = request.form.get('email')
        nueva_contraseña = request.form.get('password')

        if nueva_contraseña:
            usuario.password = Usuario.hash_password(nueva_contraseña)

        usuario.save()
        flash('Usuario actualizado correctamente', 'success')
        return redirect(url_for('gestionar_usuarios'))

    return render_template('usuarios/usuarios_editar.html', usuario=usuario)


@app.route('/usuarios/<int:usuario_id>/eliminar', methods=['POST'])
def eliminar_usuario(usuario_id):
    """
    Vista para eliminar un usuario (solo administradores).
    
    Args:
        usuario_id (int): ID del usuario a eliminar
    """
    if not session.get('es_admin'):
        flash('Acceso denegado', 'danger')
        return redirect(url_for('home'))

    admin_password = request.form.get('admin_password')

    admin = Usuario.get_by_id(session['usuario_id'])
    if not admin or not Usuario.verify_password(admin.password, admin_password):
        flash('Contraseña de administrador incorrecta', 'danger')
        return redirect(url_for('gestionar_usuarios'))

    usuario = Usuario.get_by_id(usuario_id)
    if not usuario:
        flash('Usuario no encontrado', 'danger')
        return redirect(url_for('gestionar_usuarios'))

    if usuario.id == admin.id:
        flash('No puedes eliminar tu propio usuario', 'danger')
        return redirect(url_for('gestionar_usuarios'))

    usuario.delete()
    flash('Usuario eliminado correctamente', 'success')
    return redirect(url_for('gestionar_usuarios'))


# ===================================================================
# PÁGINA DE INICIO
# ===================================================================

@app.route('/')
def home():
    """
    Vista de la página principal.
    """
    # Obtener productos destacados para mostrar
    productos = Producto.get_destacados(8)

    return render_template('index.html', productos=productos)


# ===================================================================
# RUTAS DE PRODUCTOS
# ===================================================================

@app.route('/productos')
def listar_productos():
    """
    Vista para listar todos los productos.
    """
    busqueda = request.args.get('busqueda', '')
    categoria_actual = request.args.get('categoria', '')

    # Obtener productos con filtros aplicados
    productos = Producto.get_all(busqueda=busqueda, categoria=categoria_actual)

    # Obtener todas las categorías para el filtro
    categorias = Producto.get_categorias()

    return render_template('productos/productos_listar.html',
                           productos=productos,
                           busqueda=busqueda,
                           categoria_actual=categoria_actual,
                           categorias=categorias)


@app.route('/productos/<int:producto_id>')
def ver_producto(producto_id):
    """
    Vista para ver los detalles de un producto.

    Args:
        producto_id (int): ID del producto
    """
    producto = Producto.get_by_id(producto_id)

    if not producto:
        flash('Producto no encontrado', 'danger')
        return redirect(url_for('listar_productos'))

    return render_template('productos/productos_detalle.html', producto=producto)


@app.route('/productos/crear', methods=['GET', 'POST'])
def crear_producto():
    """
    Vista para crear un nuevo producto.

    GET: Muestra el formulario de creación
    POST: Procesa la creación del producto
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    # Obtener todos los proveedores para el formulario
    proveedores = Proveedor.get_all()

    if request.method == 'POST':
        # Obtener datos del formulario
        nombre = request.form.get('nombre')
        referencia = request.form.get('referencia')
        descripcion = request.form.get('descripcion')
        precio_compra = float(request.form.get('precio_compra', 0))
        precio_venta = float(request.form.get('precio_venta', 0))
        stock_actual = int(request.form.get('stock_actual', 0))
        stock_minimo = int(request.form.get('stock_minimo', 0))
        ubicacion_almacen = request.form.get('ubicacion_almacen')
        categoria = request.form.get('categoria')
        proveedor_id = request.form.get('proveedor_id')

        # Procesar imagen si se ha subido
        imagen = None
        if 'imagen' in request.files and request.files['imagen'].filename:
            archivo = request.files['imagen']
            if archivo.filename:
                # Generar un nombre seguro para el archivo
                nombre_archivo = secure_filename(archivo.filename)
                # Agregar timestamp para evitar duplicados
                nombre_base, extension = os.path.splitext(nombre_archivo)
                timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
                nombre_archivo = f"{nombre_base}_{timestamp}{extension}"

                # Guardar la imagen
                ruta_imagen = os.path.join(app.config['UPLOAD_FOLDER'], nombre_archivo)
                archivo.save(ruta_imagen)

                # Guardar la ruta relativa para la base de datos
                imagen = os.path.join('uploads', nombre_archivo)

        # Crear el producto
        nuevo_producto = Producto(
            nombre=nombre,
            referencia=referencia,
            descripcion=descripcion,
            precio_compra=precio_compra,
            precio_venta=precio_venta,
            stock_actual=stock_actual,
            stock_minimo=stock_minimo,
            ubicacion_almacen=ubicacion_almacen,
            categoria=categoria,
            imagen=imagen,
            proveedor_id=proveedor_id if proveedor_id else None
        )

        # Guardar en la base de datos
        nuevo_producto.save()

        flash('Producto creado correctamente', 'success')
        return redirect(url_for('ver_producto', producto_id=nuevo_producto.id))

    return render_template('productos/productos_crear.html', proveedores=proveedores)


@app.route('/productos/<int:producto_id>/editar', methods=['GET', 'POST'])
def editar_producto(producto_id):
    """
    Vista para editar un producto existente.

    Args:
        producto_id (int): ID del producto a editar
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    producto = Producto.get_by_id(producto_id)

    if not producto:
        flash('Producto no encontrado', 'danger')
        return redirect(url_for('listar_productos'))

    # Obtener todos los proveedores para el formulario
    proveedores = Proveedor.get_all()

    if request.method == 'POST':
        # Obtener datos del formulario
        producto.nombre = request.form.get('nombre')
        producto.referencia = request.form.get('referencia')
        producto.descripcion = request.form.get('descripcion')
        producto.precio_compra = float(request.form.get('precio_compra', 0))
        producto.precio_venta = float(request.form.get('precio_venta', 0))
        producto.stock_actual = int(request.form.get('stock_actual', 0))
        producto.stock_minimo = int(request.form.get('stock_minimo', 0))
        producto.ubicacion_almacen = request.form.get('ubicacion_almacen')
        producto.categoria = request.form.get('categoria')
        producto.proveedor_id = request.form.get('proveedor_id')

        # Procesar imagen si se ha subido una nueva
        if 'imagen' in request.files and request.files['imagen'].filename:
            archivo = request.files['imagen']
            if archivo.filename:
                # Eliminar imagen anterior si existe
                if producto.imagen and os.path.exists(os.path.join('static', producto.imagen)):
                    os.remove(os.path.join('static', producto.imagen))

                # Generar un nombre seguro para el archivo
                nombre_archivo = secure_filename(archivo.filename)
                # Agregar timestamp para evitar duplicados
                nombre_base, extension = os.path.splitext(nombre_archivo)
                timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
                nombre_archivo = f"{nombre_base}_{timestamp}{extension}"

                # Guardar la imagen
                ruta_imagen = os.path.join(app.config['UPLOAD_FOLDER'], nombre_archivo)
                archivo.save(ruta_imagen)

                # Guardar la ruta relativa para la base de datos
                producto.imagen = f"uploads/{nombre_archivo}"

        # Guardar cambios
        producto.save()

        flash('Producto actualizado correctamente', 'success')
        return redirect(url_for('ver_producto', producto_id=producto.id))

    return render_template('productos/productos_editar.html', producto=producto, proveedores=proveedores)


@app.route('/productos/<int:producto_id>/eliminar', methods=['POST'])
def eliminar_producto(producto_id):
    """
    Vista para eliminar un producto.

    Args:
        producto_id (int): ID del producto a eliminar
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para realizar esta acción', 'danger')
        return redirect(url_for('home'))

    producto = Producto.get_by_id(producto_id)

    if not producto:
        flash('Producto no encontrado', 'danger')
        return redirect(url_for('listar_productos'))

    # Intentar eliminar el producto
    if producto.delete():
        # Eliminar imagen si existe
        if producto.imagen and os.path.exists(os.path.join('static', producto.imagen)):
            os.remove(os.path.join('static', producto.imagen))

        flash('Producto eliminado correctamente', 'success')
    else:
        flash('No se puede eliminar el producto porque tiene ventas o compras asociadas', 'danger')

    return redirect(url_for('listar_productos'))


@app.route('/api/productos-proveedor')
def api_productos_por_proveedor():
    """
    API para obtener productos de un proveedor específico.
    """
    proveedor_id = request.args.get('id')
    if not proveedor_id:
        return jsonify([])

    productos = Producto.get_by_proveedor(proveedor_id)
    return jsonify([{
        'id': p.id,
        'nombre': p.nombre,
        'precio': p.precio_compra
    } for p in productos])


# ===================================================================
# RUTAS DE PROVEEDORES
# ===================================================================

@app.route('/proveedores')
def listar_proveedores():
    """
    Vista para listar todos los proveedores.
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    # Obtener todos los proveedores
    proveedores = Proveedor.get_all()

    return render_template('proveedores/proveedores_listar.html', proveedores=proveedores)


@app.route('/proveedores/<int:proveedor_id>')
def ver_proveedor(proveedor_id):
    """
    Vista para ver los detalles de un proveedor.

    Args:
        proveedor_id (int): ID del proveedor
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    proveedor = Proveedor.get_by_id(proveedor_id)

    if not proveedor:
        flash('Proveedor no encontrado', 'danger')
        return redirect(url_for('listar_proveedores'))

    # Obtener productos y compras asociadas al proveedor
    productos = Producto.get_by_proveedor(proveedor_id)
    compras = Compra.get_all(proveedor_id=proveedor_id)[:5]  # Solo las 5 últimas compras

    return render_template('proveedores/proveedores_detalle.html',
                           proveedor=proveedor,
                           productos=productos,
                           compras=compras)


@app.route('/proveedores/crear', methods=['GET', 'POST'])
def crear_proveedor():
    """
    Vista para crear un nuevo proveedor.

    GET: Muestra el formulario de creación
    POST: Procesa la creación del proveedor
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    if request.method == 'POST':
        # Obtener datos del formulario
        nombre = request.form.get('nombre')
        cif = request.form.get('cif')
        direccion = request.form.get('direccion')
        telefono = request.form.get('telefono')
        email = request.form.get('email')
        porcentaje_descuento = float(request.form.get('porcentaje_descuento', 0))
        iva = float(request.form.get('iva', 21))
        notas = request.form.get('notas')

        # Crear el proveedor
        nuevo_proveedor = Proveedor(
            nombre=nombre,
            cif=cif,
            direccion=direccion,
            telefono=telefono,
            email=email,
            porcentaje_descuento=porcentaje_descuento,
            iva=iva,
            notas=notas
        )

        # Guardar en la base de datos
        nuevo_proveedor.save()

        flash('Proveedor creado correctamente', 'success')
        return redirect(url_for('ver_proveedor', proveedor_id=nuevo_proveedor.id))

    return render_template('proveedores/proveedores_crear.html')


@app.route('/proveedores/<int:proveedor_id>/editar', methods=['GET', 'POST'])
def editar_proveedor(proveedor_id):
    """
    Vista para editar un proveedor existente.

    Args:
        proveedor_id (int): ID del proveedor a editar
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    proveedor = Proveedor.get_by_id(proveedor_id)

    if not proveedor:
        flash('Proveedor no encontrado', 'danger')
        return redirect(url_for('listar_proveedores'))

    if request.method == 'POST':
        # Obtener datos del formulario
        proveedor.nombre = request.form.get('nombre')
        proveedor.cif = request.form.get('cif')
        proveedor.direccion = request.form.get('direccion')
        proveedor.telefono = request.form.get('telefono')
        proveedor.email = request.form.get('email')
        proveedor.porcentaje_descuento = float(request.form.get('porcentaje_descuento', 0))
        proveedor.iva = float(request.form.get('iva', 21))
        proveedor.notas = request.form.get('notas')

        # Guardar cambios
        proveedor.save()

        flash('Proveedor actualizado correctamente', 'success')
        return redirect(url_for('ver_proveedor', proveedor_id=proveedor.id))

    return render_template('proveedores/proveedores_editar.html', proveedor=proveedor)


@app.route('/proveedores/<int:proveedor_id>/eliminar', methods=['POST'])
def eliminar_proveedor(proveedor_id):
    """
    Vista para eliminar un proveedor.

    Args:
        proveedor_id (int): ID del proveedor a eliminar
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para realizar esta acción', 'danger')
        return redirect(url_for('home'))

    proveedor = Proveedor.get_by_id(proveedor_id)

    if not proveedor:
        flash('Proveedor no encontrado', 'danger')
        return redirect(url_for('listar_proveedores'))

    # Intentar eliminar el proveedor
    if proveedor.delete():
        flash('Proveedor eliminado correctamente', 'success')
    else:
        flash('No se puede eliminar el proveedor porque tiene productos asociados', 'danger')

    return redirect(url_for('listar_proveedores'))


# ===================================================================
# RUTAS DE VENTAS
# ===================================================================

@app.route('/ventas')
def listar_ventas():
    """
    Vista para listar las ventas.
    """
    # Verificar si el usuario está autenticado
    if not session.get('usuario_id'):
        flash('Debes iniciar sesión para acceder a esta página', 'warning')
        return redirect(url_for('login'))

    # Obtener parámetros de filtrado
    desde_str = request.args.get('fecha_desde')
    hasta_str = request.args.get('fecha_hasta')

    desde = None
    hasta = None

    if desde_str:
        desde = datetime.datetime.strptime(desde_str, '%Y-%m-%d')

    if hasta_str:
        hasta = datetime.datetime.strptime(hasta_str, '%Y-%m-%d')
        # Ajustar hasta al final del día
        hasta = hasta.replace(hour=23, minute=59, second=59)

    # Obtener ventas según rol del usuario
    if session.get('es_admin'):
        ventas = Venta.get_all(desde=desde, hasta=hasta)
    else:
        # Si es cliente normal, solo sus ventas
        ventas = Venta.get_by_cliente(session['usuario_id'], desde=desde, hasta=hasta)

    return render_template('ventas/ventas_listar.html', ventas=ventas)


@app.route('/ventas/<int:venta_id>')
def ver_venta(venta_id):
    """
    Vista para ver los detalles de una venta.

    Args:
        venta_id (int): ID de la venta
    """
    # Verificar si el usuario está autenticado
    if not session.get('usuario_id'):
        flash('Debes iniciar sesión para acceder a esta página', 'warning')
        return redirect(url_for('login'))

    venta = Venta.get_by_id(venta_id)

    if not venta:
        flash('Venta no encontrada', 'danger')
        return redirect(url_for('listar_ventas'))

    # Verificar permisos: solo el cliente propietario o admin puede ver sus ventas
    if not session.get('es_admin') and venta.cliente_id != session['usuario_id']:
        flash('No tienes permisos para ver esta venta', 'danger')
        return redirect(url_for('listar_ventas'))

    # Obtener detalles de la venta
    detalles = venta.get_detalles()

    return render_template('ventas/ventas_detalle.html', venta=venta, detalles=detalles)


@app.route('/ventas/crear', methods=['GET', 'POST'])
def crear_venta():
    """
    Vista para crear una nueva venta (carrito de compra).

    GET: Muestra la página del carrito
    POST: Procesa la finalización de la compra
    """
    # Verificar si el usuario está autenticado
    if not session.get('usuario_id'):
        flash('Debes iniciar sesión para realizar compras', 'warning')
        return redirect(url_for('login'))

    # Para mostrar productos recomendados
    productos = Producto.get_destacados(4)

    if request.method == 'POST':
        # Obtener datos del carrito
        carrito_datos = request.form.get('carrito_datos')

        if not carrito_datos:
            flash('El carrito está vacío', 'warning')
            return redirect(url_for('crear_venta'))

        try:
            # Convertir JSON a lista de productos
            carrito = json.loads(carrito_datos)

            if not carrito:
                flash('El carrito está vacío', 'warning')
                return redirect(url_for('crear_venta'))

            # Calcular total
            total = 0
            for item in carrito:
                total += float(item['precio']) * int(item['cantidad'])

            # Crear la venta
            nueva_venta = Venta(
                cliente_id=session['usuario_id'],
                total=total
            )

            nueva_venta.save()

            # Crear los detalles de la venta
            for item in carrito:
                producto_id = int(item['id'])
                cantidad = int(item['cantidad'])
                precio = float(item['precio'])

                # Verificar stock
                producto = Producto.get_by_id(producto_id)
                if not producto:
                    continue

                if producto.stock_actual < cantidad:
                    # Si no hay suficiente stock, ajustar cantidad
                    cantidad = producto.stock_actual
                    if cantidad <= 0:
                        continue

                # Crear detalle
                detalle = VentaDetalle(
                    venta_id=nueva_venta.id,
                    producto_id=producto_id,
                    cantidad=cantidad,
                    precio_unitario=precio
                )

                detalle.save()

            flash('Compra realizada correctamente', 'success')
            return redirect(url_for('ver_venta', venta_id=nueva_venta.id))

        except Exception as e:
            flash(f'Error al procesar la compra: {str(e)}', 'danger')
            return redirect(url_for('crear_venta'))

    return render_template('ventas/ventas_crear.html', productos=productos)


# ===================================================================
# RUTAS DE COMPRAS (A PROVEEDORES)
# ===================================================================

@app.route('/compras')
def listar_compras():
    """
    Vista para listar las compras a proveedores.
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    # Obtener parámetros de filtrado
    desde_str = request.args.get('fecha_desde')
    hasta_str = request.args.get('fecha_hasta')

    desde = None
    hasta = None

    if desde_str:
        desde = datetime.datetime.strptime(desde_str, '%Y-%m-%d')

    if hasta_str:
        hasta = datetime.datetime.strptime(hasta_str, '%Y-%m-%d')
        # Ajustar hasta al final del día
        hasta = hasta.replace(hour=23, minute=59, second=59)

    # Obtener compras con filtros
    compras = Compra.get_all(desde=desde, hasta=hasta)

    return render_template('compras/compras_listar.html', compras=compras)


@app.route('/compras/<int:compra_id>')
def ver_compra(compra_id):
    """
    Vista para ver los detalles de una compra.

    Args:
        compra_id (int): ID de la compra
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    compra = Compra.get_by_id(compra_id)

    if not compra:
        flash('Compra no encontrada', 'danger')
        return redirect(url_for('listar_compras'))

    # Obtener detalles de la compra
    detalles = compra.get_detalles()

    return render_template('compras/compras_detalle.html', compra=compra, detalles=detalles)


@app.route('/compras/crear', methods=['GET', 'POST'])
def crear_compra():
    """
    Vista para registrar una nueva compra a proveedor.

    GET: Muestra el formulario de creación
    POST: Procesa el registro de la compra
    """
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        flash('No tienes permisos para acceder a esta página', 'danger')
        return redirect(url_for('home'))

    # Obtener proveedores y productos para el formulario
    proveedores = Proveedor.get_all()
    productos = Producto.get_all()

    if request.method == 'POST':
        # Obtener datos del formulario
        proveedor_id = request.form.get('proveedor_id')

        if not proveedor_id:
            flash('Debes seleccionar un proveedor', 'danger')
            return render_template('compras/compras_crear.html',
                                   proveedores=proveedores,
                                   productos=productos)

        # Obtener datos de los productos
        productos_datos = request.form.get('productos_datos')

        if not productos_datos:
            flash('Debes agregar al menos un producto', 'danger')
            return render_template('compras/compras_crear.html',
                                   proveedores=proveedores,
                                   productos=productos)

        try:
            # Convertir JSON a lista de productos
            productos_lista = json.loads(productos_datos)

            if not productos_lista:
                flash('Debes agregar al menos un producto', 'danger')
                return render_template('compras/compras_crear.html',
                                       proveedores=proveedores,
                                       productos=productos)

            # Calcular total
            total = 0
            for item in productos_lista:
                total += float(item['precio']) * int(item['cantidad'])

            # Crear la compra
            nueva_compra = Compra(
                proveedor_id=proveedor_id,
                total=total
            )

            nueva_compra.save()

            # Crear los detalles de la compra
            for item in productos_lista:
                producto_id = int(item['id'])
                cantidad = int(item['cantidad'])
                precio = float(item['precio'])

                # Verificar que el producto existe
                producto = Producto.get_by_id(producto_id)
                if not producto:
                    continue

                # Crear detalle
                detalle = CompraDetalle(
                    compra_id=nueva_compra.id,
                    producto_id=producto_id,
                    cantidad=cantidad,
                    precio_unitario=precio
                )

                detalle.save()

            flash('Compra registrada correctamente', 'success')
            return redirect(url_for('ver_compra', compra_id=nueva_compra.id))

        except Exception as e:
            flash(f'Error al procesar la compra: {str(e)}', 'danger')
            return render_template('compras/compras_crear.html',
                                   proveedores=proveedores,
                                   productos=productos)

    return render_template('compras/compras_crear.html',
                           proveedores=proveedores,
                           productos=productos)


# ===================================================================
# RUTAS DE ESTADÍSTICAS Y API
# ===================================================================

@app.route('/estadisticas')
def estadisticas():
    """
    Vista para mostrar estadísticas.
    """
    # Verificar si el usuario está autenticado
    if not session.get('usuario_id'):
        flash('Debes iniciar sesión para acceder a esta página', 'warning')
        return redirect(url_for('login'))

    # Mostrar diferentes vistas según el rol del usuario
    if session.get('es_admin'):
        return render_template('estadisticas/estadisticas_admin.html')
    else:
        return render_template('estadisticas/estadisticas_cliente.html')


@app.route('/api/estadisticas/ventas-mensuales')
def api_ventas_mensuales():
    """API para obtener datos de ventas mensuales."""
    # Verificar si el usuario está autenticado
    if not session.get('usuario_id'):
        return jsonify([])

    dias = int(request.args.get('dias', 30))

    # Mostrar diferentes datos según el rol del usuario
    if session.get('es_admin'):
        datos = Estadisticas.ventas_mensuales(dias=dias)
    else:
        datos = Estadisticas.ventas_mensuales(dias=dias, cliente_id=session['usuario_id'])

    return jsonify(datos)


@app.route('/api/estadisticas/productos-mas-vendidos')
def api_productos_mas_vendidos():
    """API para obtener datos de productos más vendidos."""
    # Verificar si el usuario está autenticado
    if not session.get('usuario_id'):
        return jsonify([])

    dias = int(request.args.get('dias', 30))

    # Mostrar diferentes datos según el rol del usuario
    if session.get('es_admin'):
        datos = Estadisticas.productos_mas_vendidos(dias=dias)
    else:
        datos = Estadisticas.productos_mas_vendidos(dias=dias, cliente_id=session['usuario_id'])

    return jsonify(datos)


@app.route('/api/estadisticas/beneficios-por-proveedor')
def api_beneficios_por_proveedor():
    """API para obtener datos de beneficios por proveedor."""
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        return jsonify([])

    dias = int(request.args.get('dias', 30))

    datos = Estadisticas.beneficios_por_proveedor(dias=dias)

    return jsonify(datos)


@app.route('/api/estadisticas/stock-critico')
def api_stock_critico():
    """API para obtener datos de productos con stock crítico."""
    # Verificar si el usuario es administrador
    if not session.get('es_admin'):
        return jsonify([])

    datos = Estadisticas.stock_critico()

    return jsonify(datos)


@app.route('/api/ventas')
def api_ventas():
    """API para obtener datos de ventas del usuario."""
    # Verificar si el usuario está autenticado
    if not session.get('usuario_id'):
        return jsonify([])

    # Obtener ventas según rol del usuario
    if session.get('es_admin'):
        ventas = Venta.get_all()
    else:
        ventas = Venta.get_by_cliente(session['usuario_id'])

    # Convertir a formato JSON simple
    datos = []
    for venta in ventas:
        datos.append({
            'id': venta.id,
            'fecha': venta.fecha.strftime('%d/%m/%Y %H:%M'),
            'total': f"{venta.total:.2f} €"
        })

    return jsonify(datos)


@app.route('/api/estadisticas/clientes')
def api_estadisticas_clientes():
    """API para obtener estadísticas de clientes activos."""
    if not session.get('usuario_id') or not session.get('es_admin'):
        return jsonify({'total': 0})

    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute("""
            SELECT COUNT(DISTINCT cliente_id)
            FROM ventas
            WHERE cliente_id IS NOT NULL
        """)
        total = cursor.fetchone()[0]
        return jsonify({'total': total})


# ===================================================================
# INICIALIZACIÓN DE LA APLICACIÓN
# ===================================================================

if __name__ == '__main__':
    # Crear usuario administrador por defecto si no existe
    admin = Usuario.get_by_username('admin')
    if not admin:
        nuevo_admin = Usuario(
            username='admin',
            email='admin@storecomponentes.com',
            password=Usuario.hash_password('admin123'),
            es_admin=True
        )
        nuevo_admin.save()
        print("Usuario administrador creado: admin / admin123")

    app.run(debug=True)