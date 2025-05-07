"""
Módulo con los modelos de datos de la aplicación.

Este módulo contiene las clases que representan las entidades de la base de datos
y sus métodos asociados para operaciones CRUD.

"""

from db import get_db
import datetime
import hashlib
import os

class Usuario:
    """
    Clase que representa a un usuario del sistema.
    
    Attributes:
        id (int): Identificador único del usuario
        username (str): Nombre de usuario
        email (str): Correo electrónico
        password (str): Contraseña hasheada
        es_admin (bool): Indica si el usuario tiene permisos de administrador
        fecha_registro (datetime): Fecha de registro del usuario
    """

    def __init__(self, id=None, username=None, email=None, password=None, es_admin=False, fecha_registro=None):
        """Inicializa una instancia de Usuario."""
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.es_admin = es_admin
        self.fecha_registro = fecha_registro

    @staticmethod
    def hash_password(password):
        """
        Genera un hash de la contraseña proporcionada.
        
        Args:
            password (str): Contraseña en texto plano
            
        Returns:
            str: Hash de la contraseña
        """
        salt = os.urandom(32)
        key = hashlib.pbkdf2_hmac('sha256', password.encode('utf-8'), salt, 100000)
        return salt.hex() + ':' + key.hex()

    @staticmethod
    def verify_password(stored_password, provided_password):
        """
        Verifica si una contraseña coincide con su hash almacenado.
        
        Args:
            stored_password (str): Hash almacenado
            provided_password (str): Contraseña a verificar
            
        Returns:
            bool: True si la contraseña coincide, False en caso contrario
        """
        salt_hex, key_hex = stored_password.split(':')
        salt = bytes.fromhex(salt_hex)
        stored_key = bytes.fromhex(key_hex)
        new_key = hashlib.pbkdf2_hmac('sha256', provided_password.encode('utf-8'), salt, 100000)
        return stored_key == new_key

    @classmethod
    def get_by_id(cls, usuario_id):
        """
        Obtiene un usuario por su ID.
        
        Args:
            usuario_id (int): ID del usuario a buscar
            
        Returns:
            Usuario: Objeto Usuario si se encuentra, None en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM usuarios WHERE id = ?", (usuario_id,))
            row = cursor.fetchone()
            
            if row:
                return cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                )
            return None

    @classmethod
    def get_by_username(cls, username):
        """
        Obtiene un usuario por su nombre de usuario.
        
        Args:
            username (str): Nombre de usuario
            
        Returns:
            Usuario: Objeto Usuario si se encuentra, None en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM usuarios WHERE username = ?", (username,))
            row = cursor.fetchone()
            
            if row:
                return cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                )
            return None

    def save(self):
        """
        Guarda o actualiza el usuario en la base de datos.
        
        Returns:
            int: ID del usuario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            if self.id:
                # Actualizar usuario existente
                cursor.execute("""
                UPDATE usuarios SET
                    username = ?,
                    email = ?,
                    password = ?,
                    es_admin = ?
                WHERE id = ?
                """, (self.username, self.email, self.password, self.es_admin, self.id))
            else:
                # Crear nuevo usuario
                cursor.execute("""
                INSERT INTO usuarios (username, email, password, es_admin)
                VALUES (?, ?, ?, ?)
                """, (self.username, self.email, self.password, self.es_admin))
                self.id = cursor.lastrowid
                
            return self.id

    @classmethod
    def buscar(cls, texto):
        """Busca usuarios por nombre de usuario o email."""
        with get_db() as conn:
            cursor = conn.cursor()
            query = """
                SELECT * FROM usuarios
                WHERE username LIKE ? OR email LIKE ?
                ORDER BY username
            """
            like_text = f"%{texto}%"
            cursor.execute(query, (like_text, like_text))
            return [
                cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                ) for row in cursor.fetchall()
            ]

    def delete(self):
        """Elimina el usuario de la base de datos."""
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM usuarios WHERE id = ?", (self.id,))
            return cursor.rowcount > 0


class Proveedor:
    """
    Clase que representa a un proveedor del sistema.
    
    Attributes:
        id (int): Identificador único del proveedor
        nombre (str): Nombre de la empresa proveedora
        cif (str): CIF/NIF del proveedor
        direccion (str): Dirección física
        telefono (str): Número de teléfono
        email (str): Correo electrónico
        porcentaje_descuento (float): Porcentaje de descuento que aplica
        iva (float): Porcentaje de IVA aplicable
        notas (str): Notas adicionales
    """

    def __init__(self, id=None, nombre=None, cif=None, direccion=None, telefono=None, 
                 email=None, porcentaje_descuento=0, iva=21, notas=None):
        """Inicializa una instancia de Proveedor."""
        self.id = id
        self.nombre = nombre
        self.cif = cif
        self.direccion = direccion
        self.telefono = telefono
        self.email = email
        self.porcentaje_descuento = porcentaje_descuento
        self.iva = iva
        self.notas = notas

    @classmethod
    def get_by_id(cls, proveedor_id):
        """
        Obtiene un proveedor por su ID.
        
        Args:
            proveedor_id (int): ID del proveedor a buscar
            
        Returns:
            Proveedor: Objeto Proveedor si se encuentra, None en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM proveedores WHERE id = ?", (proveedor_id,))
            row = cursor.fetchone()
            
            if row:
                return cls(
                    id=row['id'],
                    nombre=row['nombre'],
                    cif=row['cif'],
                    direccion=row['direccion'],
                    telefono=row['telefono'],
                    email=row['email'],
                    porcentaje_descuento=row['porcentaje_descuento'],
                    iva=row['iva'],
                    notas=row['notas']
                )
            return None

    @classmethod
    def get_all(cls):
        """
        Obtiene todos los proveedores.
        
        Returns:
            list: Lista de objetos Proveedor
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM proveedores ORDER BY nombre")
            return [cls(
                id=row['id'],
                nombre=row['nombre'],
                cif=row['cif'],
                direccion=row['direccion'],
                telefono=row['telefono'],
                email=row['email'],
                porcentaje_descuento=row['porcentaje_descuento'],
                iva=row['iva'],
                notas=row['notas']
            ) for row in cursor.fetchall()]

    def save(self):
        """
        Guarda o actualiza el proveedor en la base de datos.
        
        Returns:
            int: ID del proveedor
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            if self.id:
                # Actualizar proveedor existente
                cursor.execute("""
                UPDATE proveedores SET
                    nombre = ?,
                    cif = ?,
                    direccion = ?,
                    telefono = ?,
                    email = ?,
                    porcentaje_descuento = ?,
                    iva = ?,
                    notas = ?
                WHERE id = ?
                """, (self.nombre, self.cif, self.direccion, self.telefono, 
                      self.email, self.porcentaje_descuento, self.iva, 
                      self.notas, self.id))
            else:
                # Crear nuevo proveedor
                cursor.execute("""
                INSERT INTO proveedores (nombre, cif, direccion, telefono, email, 
                                        porcentaje_descuento, iva, notas)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, (self.nombre, self.cif, self.direccion, self.telefono, 
                      self.email, self.porcentaje_descuento, self.iva, self.notas))
                self.id = cursor.lastrowid
                
            return self.id

    @classmethod
    def buscar(cls, texto):
        """Busca usuarios por nombre de usuario o email."""
        with get_db() as conn:
            cursor = conn.cursor()
            query = """
                SELECT * FROM usuarios
                WHERE username LIKE ? OR email LIKE ?
                ORDER BY username
            """
            like_text = f"%{texto}%"
            cursor.execute(query, (like_text, like_text))
            return [
                cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                ) for row in cursor.fetchall()
            ]

    def delete(self):
        """Elimina el usuario de la base de datos."""
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM usuarios WHERE id = ?", (self.id,))
            return cursor.rowcount > 0

    def delete(self):
        """
        Elimina el proveedor de la base de datos.
        
        Returns:
            bool: True si se eliminó correctamente, False en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            # Verificar si hay productos asociados
            cursor.execute("SELECT COUNT(*) FROM productos WHERE proveedor_id = ?", (self.id,))
            if cursor.fetchone()[0] > 0:
                return False
                
            cursor.execute("DELETE FROM proveedores WHERE id = ?", (self.id,))
            return cursor.rowcount > 0


class Producto:
    """
    Clase que representa un producto del sistema.
    
    Attributes:
        id (int): Identificador único del producto
        nombre (str): Nombre del producto
        referencia (str): Código o referencia única
        descripcion (str): Descripción detallada
        precio_compra (float): Precio de compra al proveedor
        precio_venta (float): Precio de venta al cliente
        stock_actual (int): Cantidad en stock
        stock_minimo (int): Cantidad mínima de stock
        ubicacion_almacen (str): Ubicación en el almacén
        categoria (str): Categoría del producto
        imagen (str): Ruta a la imagen del producto
        proveedor_id (int): ID del proveedor
        proveedor (Proveedor): Objeto proveedor (relación)
    """

    def __init__(self, id=None, nombre=None, referencia=None, descripcion=None,
                 precio_compra=0, precio_venta=0, stock_actual=0, stock_minimo=0,
                 ubicacion_almacen=None, categoria=None, imagen=None, proveedor_id=None,
                 proveedor=None):
        """Inicializa una instancia de Producto."""
        self.id = id
        self.nombre = nombre
        self.referencia = referencia
        self.descripcion = descripcion
        self.precio_compra = precio_compra
        self.precio_venta = precio_venta
        self.stock_actual = stock_actual
        self.stock_minimo = stock_minimo
        self.ubicacion_almacen = ubicacion_almacen
        self.categoria = categoria
        self.imagen = imagen
        self.proveedor_id = proveedor_id
        self.proveedor = proveedor

    @classmethod
    def get_by_id(cls, producto_id):
        """
        Obtiene un producto por su ID.
        
        Args:
            producto_id (int): ID del producto a buscar
            
        Returns:
            Producto: Objeto Producto si se encuentra, None en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT p.*, prov.nombre as proveedor_nombre, prov.cif as proveedor_cif
            FROM productos p
            LEFT JOIN proveedores prov ON p.proveedor_id = prov.id
            WHERE p.id = ?
            """, (producto_id,))
            row = cursor.fetchone()
            
            if row:
                producto = cls(
                    id=row['id'],
                    nombre=row['nombre'],
                    referencia=row['referencia'],
                    descripcion=row['descripcion'],
                    precio_compra=row['precio_compra'],
                    precio_venta=row['precio_venta'],
                    stock_actual=row['stock_actual'],
                    stock_minimo=row['stock_minimo'],
                    ubicacion_almacen=row['ubicacion_almacen'],
                    categoria=row['categoria'],
                    imagen=row['imagen'],
                    proveedor_id=row['proveedor_id']
                )
                
                if producto.proveedor_id:
                    producto.proveedor = Proveedor(
                        id=row['proveedor_id'],
                        nombre=row['proveedor_nombre'],
                        cif=row['proveedor_cif']
                    )
                
                return producto
            return None

    @classmethod
    def get_all(cls, busqueda=None, categoria=None):
        """
        Obtiene todos los productos con filtros opcionales.
        
        Args:
            busqueda (str, optional): Texto para filtrar por nombre o referencia
            categoria (str, optional): Categoría para filtrar
            
        Returns:
            list: Lista de objetos Producto
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT p.*, prov.nombre as proveedor_nombre
            FROM productos p
            LEFT JOIN proveedores prov ON p.proveedor_id = prov.id
            """
            
            params = []
            conditions = []
            
            if busqueda:
                conditions.append("(p.nombre LIKE ? OR p.referencia LIKE ?)")
                params.extend([f"%{busqueda}%", f"%{busqueda}%"])
                
            if categoria:
                conditions.append("p.categoria = ?")
                params.append(categoria)
                
            if conditions:
                query += " WHERE " + " AND ".join(conditions)
                
            query += " ORDER BY p.nombre"
            
            cursor.execute(query, params)
            
            productos = []
            for row in cursor.fetchall():
                producto = cls(
                    id=row['id'],
                    nombre=row['nombre'],
                    referencia=row['referencia'],
                    descripcion=row['descripcion'],
                    precio_compra=row['precio_compra'],
                    precio_venta=row['precio_venta'],
                    stock_actual=row['stock_actual'],
                    stock_minimo=row['stock_minimo'],
                    ubicacion_almacen=row['ubicacion_almacen'],
                    categoria=row['categoria'],
                    imagen=row['imagen'],
                    proveedor_id=row['proveedor_id']
                )
                
                if producto.proveedor_id:
                    producto.proveedor = Proveedor(
                        id=row['proveedor_id'],
                        nombre=row['proveedor_nombre']
                    )
                
                productos.append(producto)
                
            return productos

    @classmethod
    def get_by_proveedor(cls, proveedor_id):
        """
        Obtiene todos los productos de un proveedor específico.
        
        Args:
            proveedor_id (int): ID del proveedor
            
        Returns:
            list: Lista de objetos Producto
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT * FROM productos WHERE proveedor_id = ?
            ORDER BY nombre
            """, (proveedor_id,))
            
            return [cls(
                id=row['id'],
                nombre=row['nombre'],
                referencia=row['referencia'],
                descripcion=row['descripcion'],
                precio_compra=row['precio_compra'],
                precio_venta=row['precio_venta'],
                stock_actual=row['stock_actual'],
                stock_minimo=row['stock_minimo'],
                ubicacion_almacen=row['ubicacion_almacen'],
                categoria=row['categoria'],
                imagen=row['imagen'],
                proveedor_id=row['proveedor_id']
            ) for row in cursor.fetchall()]

    @classmethod
    def get_destacados(cls, limit=4):
        """
        Obtiene los productos destacados (mayor margen).
        
        Args:
            limit (int): Número máximo de productos a devolver
            
        Returns:
            list: Lista de objetos Producto
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT * FROM productos
            WHERE stock_actual > 0
            ORDER BY (precio_venta - precio_compra) / precio_compra DESC, stock_actual DESC
            LIMIT ?
            """, (limit,))
            
            return [cls(
                id=row['id'],
                nombre=row['nombre'],
                referencia=row['referencia'],
                descripcion=row['descripcion'],
                precio_compra=row['precio_compra'],
                precio_venta=row['precio_venta'],
                stock_actual=row['stock_actual'],
                stock_minimo=row['stock_minimo'],
                ubicacion_almacen=row['ubicacion_almacen'],
                categoria=row['categoria'],
                imagen=row['imagen'],
                proveedor_id=row['proveedor_id']
            ) for row in cursor.fetchall()]
            
    @classmethod
    def get_categorias(cls):
        """
        Obtiene todas las categorías distintas.
        
        Returns:
            list: Lista de categorías
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT DISTINCT categoria FROM productos
            WHERE categoria IS NOT NULL AND categoria != ''
            ORDER BY categoria
            """)
            
            return [row['categoria'] for row in cursor.fetchall()]

    def save(self):
        """
        Guarda o actualiza el producto en la base de datos.
        
        Returns:
            int: ID del producto
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            if self.id:
                # Actualizar producto existente
                cursor.execute("""
                UPDATE productos SET
                    nombre = ?,
                    referencia = ?,
                    descripcion = ?,
                    precio_compra = ?,
                    precio_venta = ?,
                    stock_actual = ?,
                    stock_minimo = ?,
                    ubicacion_almacen = ?,
                    categoria = ?,
                    imagen = ?,
                    proveedor_id = ?
                WHERE id = ?
                """, (self.nombre, self.referencia, self.descripcion, self.precio_compra,
                      self.precio_venta, self.stock_actual, self.stock_minimo,
                      self.ubicacion_almacen, self.categoria, self.imagen,
                      self.proveedor_id, self.id))
            else:
                # Crear nuevo producto
                cursor.execute("""
                INSERT INTO productos (nombre, referencia, descripcion, precio_compra,
                                      precio_venta, stock_actual, stock_minimo,
                                      ubicacion_almacen, categoria, imagen, proveedor_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (self.nombre, self.referencia, self.descripcion, self.precio_compra,
                      self.precio_venta, self.stock_actual, self.stock_minimo,
                      self.ubicacion_almacen, self.categoria, self.imagen, self.proveedor_id))
                self.id = cursor.lastrowid
                
            return self.id

    @classmethod
    def buscar(cls, texto):
        """Busca usuarios por nombre de usuario o email."""
        with get_db() as conn:
            cursor = conn.cursor()
            query = """
                SELECT * FROM usuarios
                WHERE username LIKE ? OR email LIKE ?
                ORDER BY username
            """
            like_text = f"%{texto}%"
            cursor.execute(query, (like_text, like_text))
            return [
                cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                ) for row in cursor.fetchall()
            ]

    def delete(self):
        """Elimina el usuario de la base de datos."""
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM usuarios WHERE id = ?", (self.id,))
            return cursor.rowcount > 0

    def delete(self):
        """
        Elimina el producto de la base de datos.
        
        Returns:
            bool: True si se eliminó correctamente, False en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            # Verificar si hay ventas o compras relacionadas
            cursor.execute("""
            SELECT COUNT(*) FROM ventas_detalle WHERE producto_id = ?
            UNION ALL
            SELECT COUNT(*) FROM compras_detalle WHERE producto_id = ?
            """, (self.id, self.id))
            
            resultados = cursor.fetchall()
            if resultados[0][0] > 0 or resultados[1][0] > 0:
                return False
                
            cursor.execute("DELETE FROM productos WHERE id = ?", (self.id,))
            return cursor.rowcount > 0


class Venta:
    """
    Clase que representa una venta (pedido de cliente).
    
    Attributes:
        id (int): Identificador único de la venta
        cliente_id (int): ID del usuario cliente
        fecha (datetime): Fecha y hora de la venta
        total (float): Importe total de la venta
        cliente (Usuario): Objeto usuario cliente (relación)
    """

    def __init__(self, id=None, cliente_id=None, fecha=None, total=0, cliente=None):
        """Inicializa una instancia de Venta."""
        self.id = id
        self.cliente_id = cliente_id
        self.fecha = fecha or datetime.datetime.now()
        self.total = total
        self.cliente = cliente

    @classmethod
    def get_by_id(cls, venta_id):
        """
        Obtiene una venta por su ID.
        
        Args:
            venta_id (int): ID de la venta a buscar
            
        Returns:
            Venta: Objeto Venta si se encuentra, None en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT v.*, u.username, u.email
            FROM ventas v
            JOIN usuarios u ON v.cliente_id = u.id
            WHERE v.id = ?
            """, (venta_id,))
            row = cursor.fetchone()
            
            if row:
                venta = cls(
                    id=row['id'],
                    cliente_id=row['cliente_id'],
                    fecha=datetime.datetime.fromisoformat(row['fecha']),
                    total=row['total']
                )
                
                venta.cliente = Usuario(
                    id=row['cliente_id'],
                    username=row['username'],
                    email=row['email']
                )
                
                return venta
            return None

    @classmethod
    def get_by_cliente(cls, cliente_id, desde=None, hasta=None):
        """
        Obtiene todas las ventas de un cliente con filtros opcionales.
        
        Args:
            cliente_id (int): ID del cliente
            desde (datetime, optional): Fecha de inicio para filtrar
            hasta (datetime, optional): Fecha de fin para filtrar
            
        Returns:
            list: Lista de objetos Venta
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT v.*, u.username, u.email
            FROM ventas v
            JOIN usuarios u ON v.cliente_id = u.id
            WHERE v.cliente_id = ?
            """
            
            params = [cliente_id]
            
            if desde:
                query += " AND v.fecha >= ?"
                params.append(desde.isoformat())
                
            if hasta:
                query += " AND v.fecha <= ?"
                params.append(hasta.isoformat())
                
            query += " ORDER BY v.fecha DESC"
            
            cursor.execute(query, params)
            
            ventas = []
            for row in cursor.fetchall():
                venta = cls(
                    id=row['id'],
                    cliente_id=row['cliente_id'],
                    fecha=datetime.datetime.fromisoformat(row['fecha']),
                    total=row['total']
                )
                
                venta.cliente = Usuario(
                    id=row['cliente_id'],
                    username=row['username'],
                    email=row['email']
                )
                
                ventas.append(venta)
                
            return ventas

    @classmethod
    def get_all(cls, desde=None, hasta=None):
        """
        Obtiene todas las ventas con filtros opcionales.
        
        Args:
            desde (datetime, optional): Fecha de inicio para filtrar
            hasta (datetime, optional): Fecha de fin para filtrar
            
        Returns:
            list: Lista de objetos Venta
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT v.*, u.username, u.email
            FROM ventas v
            JOIN usuarios u ON v.cliente_id = u.id
            """
            
            params = []
            
            if desde:
                query += " WHERE v.fecha >= ?"
                params.append(desde.isoformat())
                
                if hasta:
                    query += " AND v.fecha <= ?"
                    params.append(hasta.isoformat())
            elif hasta:
                query += " WHERE v.fecha <= ?"
                params.append(hasta.isoformat())
                
            query += " ORDER BY v.fecha DESC"
            
            cursor.execute(query, params)
            
            ventas = []
            for row in cursor.fetchall():
                venta = cls(
                    id=row['id'],
                    cliente_id=row['cliente_id'],
                    fecha=datetime.datetime.fromisoformat(row['fecha']),
                    total=row['total']
                )
                
                venta.cliente = Usuario(
                    id=row['cliente_id'],
                    username=row['username'],
                    email=row['email']
                )
                
                ventas.append(venta)
                
            return ventas

    def save(self):
        """
        Guarda o actualiza la venta en la base de datos.
        
        Returns:
            int: ID de la venta
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            if self.id:
                # Actualizar venta existente
                cursor.execute("""
                UPDATE ventas SET
                    cliente_id = ?,
                    total = ?
                WHERE id = ?
                """, (self.cliente_id, self.total, self.id))
            else:
                # Crear nueva venta
                cursor.execute("""
                INSERT INTO ventas (cliente_id, total)
                VALUES (?, ?)
                """, (self.cliente_id, self.total))
                self.id = cursor.lastrowid
                
            return self.id

    @classmethod
    def buscar(cls, texto):
        """Busca usuarios por nombre de usuario o email."""
        with get_db() as conn:
            cursor = conn.cursor()
            query = """
                SELECT * FROM usuarios
                WHERE username LIKE ? OR email LIKE ?
                ORDER BY username
            """
            like_text = f"%{texto}%"
            cursor.execute(query, (like_text, like_text))
            return [
                cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                ) for row in cursor.fetchall()
            ]

    def delete(self):
        """Elimina el usuario de la base de datos."""
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM usuarios WHERE id = ?", (self.id,))
            return cursor.rowcount > 0

    def get_detalles(self):
        """
        Obtiene los detalles de una venta.
        
        Returns:
            list: Lista de objetos VentaDetalle
        """
        return VentaDetalle.get_by_venta(self.id)


class VentaDetalle:
    """
    Clase que representa un detalle de venta.
    
    Attributes:
        id (int): Identificador único del detalle
        venta_id (int): ID de la venta
        producto_id (int): ID del producto
        cantidad (int): Cantidad de unidades
        precio_unitario (float): Precio unitario aplicado
        producto (Producto): Objeto producto (relación)
    """

    def __init__(self, id=None, venta_id=None, producto_id=None, cantidad=0, 
                 precio_unitario=0, producto=None):
        """Inicializa una instancia de VentaDetalle."""
        self.id = id
        self.venta_id = venta_id
        self.producto_id = producto_id
        self.cantidad = cantidad
        self.precio_unitario = precio_unitario
        self.producto = producto

    @classmethod
    def get_by_venta(cls, venta_id):
        """
        Obtiene todos los detalles de una venta.
        
        Args:
            venta_id (int): ID de la venta
            
        Returns:
            list: Lista de objetos VentaDetalle
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT d.*, p.nombre as producto_nombre, p.referencia as producto_referencia
            FROM ventas_detalle d
            JOIN productos p ON d.producto_id = p.id
            WHERE d.venta_id = ?
            """, (venta_id,))
            
            detalles = []
            for row in cursor.fetchall():
                detalle = cls(
                    id=row['id'],
                    venta_id=row['venta_id'],
                    producto_id=row['producto_id'],
                    cantidad=row['cantidad'],
                    precio_unitario=row['precio_unitario']
                )
                
                detalle.producto = Producto(
                    id=row['producto_id'],
                    nombre=row['producto_nombre'],
                    referencia=row['producto_referencia']
                )
                
                detalles.append(detalle)
                
            return detalles

    def save(self):
        """
        Guarda o actualiza el detalle de venta en la base de datos.
        
        Returns:
            int: ID del detalle de venta
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            if self.id:
                # Actualizar detalle existente
                cursor.execute("""
                UPDATE ventas_detalle SET
                    venta_id = ?,
                    producto_id = ?,
                    cantidad = ?,
                    precio_unitario = ?
                WHERE id = ?
                """, (self.venta_id, self.producto_id, self.cantidad, 
                      self.precio_unitario, self.id))
            else:
                # Crear nuevo detalle
                cursor.execute("""
                INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario)
                VALUES (?, ?, ?, ?)
                """, (self.venta_id, self.producto_id, self.cantidad, self.precio_unitario))
                self.id = cursor.lastrowid
                
                # Actualizar stock del producto
                cursor.execute("""
                UPDATE productos
                SET stock_actual = stock_actual - ?
                WHERE id = ?
                """, (self.cantidad, self.producto_id))
                
            return self.id

    @classmethod
    def buscar(cls, texto):
        """Busca usuarios por nombre de usuario o email."""
        with get_db() as conn:
            cursor = conn.cursor()
            query = """
                SELECT * FROM usuarios
                WHERE username LIKE ? OR email LIKE ?
                ORDER BY username
            """
            like_text = f"%{texto}%"
            cursor.execute(query, (like_text, like_text))
            return [
                cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                ) for row in cursor.fetchall()
            ]

    def delete(self):
        """Elimina el usuario de la base de datos."""
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM usuarios WHERE id = ?", (self.id,))
            return cursor.rowcount > 0


class Compra:
    """
    Clase que representa una compra a proveedor.
    
    Attributes:
        id (int): Identificador único de la compra
        proveedor_id (int): ID del proveedor
        fecha (datetime): Fecha y hora de la compra
        total (float): Importe total de la compra
        proveedor (Proveedor): Objeto proveedor (relación)
    """

    def __init__(self, id=None, proveedor_id=None, fecha=None, total=0, proveedor=None):
        """Inicializa una instancia de Compra."""
        self.id = id
        self.proveedor_id = proveedor_id
        self.fecha = fecha or datetime.datetime.now()
        self.total = total
        self.proveedor = proveedor

    @classmethod
    def get_by_id(cls, compra_id):
        """
        Obtiene una compra por su ID.
        
        Args:
            compra_id (int): ID de la compra a buscar
            
        Returns:
            Compra: Objeto Compra si se encuentra, None en caso contrario
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT c.*, p.nombre as proveedor_nombre, p.cif as proveedor_cif,
                   p.iva as proveedor_iva
            FROM compras c
            JOIN proveedores p ON c.proveedor_id = p.id
            WHERE c.id = ?
            """, (compra_id,))
            row = cursor.fetchone()
            
            if row:
                compra = cls(
                    id=row['id'],
                    proveedor_id=row['proveedor_id'],
                    fecha=datetime.datetime.fromisoformat(row['fecha']),
                    total=row['total']
                )
                
                compra.proveedor = Proveedor(
                    id=row['proveedor_id'],
                    nombre=row['proveedor_nombre'],
                    cif=row['proveedor_cif'],
                    iva=row['proveedor_iva']
                )
                
                return compra
            return None

    @classmethod
    def get_all(cls, proveedor_id=None, desde=None, hasta=None):
        """
        Obtiene todas las compras con filtros opcionales.
        
        Args:
            proveedor_id (int, optional): ID del proveedor para filtrar
            desde (datetime, optional): Fecha de inicio para filtrar
            hasta (datetime, optional): Fecha de fin para filtrar
            
        Returns:
            list: Lista de objetos Compra
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT c.*, p.nombre as proveedor_nombre
            FROM compras c
            JOIN proveedores p ON c.proveedor_id = p.id
            """
            
            params = []
            conditions = []
            
            if proveedor_id:
                conditions.append("c.proveedor_id = ?")
                params.append(proveedor_id)
                
            if desde:
                conditions.append("c.fecha >= ?")
                params.append(desde.isoformat())
                
            if hasta:
                conditions.append("c.fecha <= ?")
                params.append(hasta.isoformat())
                
            if conditions:
                query += " WHERE " + " AND ".join(conditions)
                
            query += " ORDER BY c.fecha DESC"
            
            cursor.execute(query, params)
            
            compras = []
            for row in cursor.fetchall():
                compra = cls(
                    id=row['id'],
                    proveedor_id=row['proveedor_id'],
                    fecha=datetime.datetime.fromisoformat(row['fecha']),
                    total=row['total']
                )
                
                compra.proveedor = Proveedor(
                    id=row['proveedor_id'],
                    nombre=row['proveedor_nombre']
                )
                
                compras.append(compra)
                
            return compras

    def save(self):
        """
        Guarda o actualiza la compra en la base de datos.
        
        Returns:
            int: ID de la compra
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            if self.id:
                # Actualizar compra existente
                cursor.execute("""
                UPDATE compras SET
                    proveedor_id = ?,
                    total = ?
                WHERE id = ?
                """, (self.proveedor_id, self.total, self.id))
            else:
                # Crear nueva compra
                cursor.execute("""
                INSERT INTO compras (proveedor_id, total)
                VALUES (?, ?)
                """, (self.proveedor_id, self.total))
                self.id = cursor.lastrowid
                
            return self.id

    @classmethod
    def buscar(cls, texto):
        """Busca usuarios por nombre de usuario o email."""
        with get_db() as conn:
            cursor = conn.cursor()
            query = """
                SELECT * FROM usuarios
                WHERE username LIKE ? OR email LIKE ?
                ORDER BY username
            """
            like_text = f"%{texto}%"
            cursor.execute(query, (like_text, like_text))
            return [
                cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                ) for row in cursor.fetchall()
            ]

    def delete(self):
        """Elimina el usuario de la base de datos."""
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM usuarios WHERE id = ?", (self.id,))
            return cursor.rowcount > 0

    def get_detalles(self):
        """
        Obtiene los detalles de una compra.
        
        Returns:
            list: Lista de objetos CompraDetalle
        """
        return CompraDetalle.get_by_compra(self.id)


class CompraDetalle:
    """
    Clase que representa un detalle de compra.
    
    Attributes:
        id (int): Identificador único del detalle
        compra_id (int): ID de la compra
        producto_id (int): ID del producto
        cantidad (int): Cantidad de unidades
        precio_unitario (float): Precio unitario aplicado
        producto (Producto): Objeto producto (relación)
    """

    def __init__(self, id=None, compra_id=None, producto_id=None, cantidad=0, 
                 precio_unitario=0, producto=None):
        """Inicializa una instancia de CompraDetalle."""
        self.id = id
        self.compra_id = compra_id
        self.producto_id = producto_id
        self.cantidad = cantidad
        self.precio_unitario = precio_unitario
        self.producto = producto

    @classmethod
    def get_by_compra(cls, compra_id):
        """
        Obtiene todos los detalles de una compra.
        
        Args:
            compra_id (int): ID de la compra
            
        Returns:
            list: Lista de objetos CompraDetalle
        """
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("""
            SELECT d.*, p.nombre as producto_nombre, p.referencia as producto_referencia
            FROM compras_detalle d
            JOIN productos p ON d.producto_id = p.id
            WHERE d.compra_id = ?
            """, (compra_id,))
            
            detalles = []
            for row in cursor.fetchall():
                detalle = cls(
                    id=row['id'],
                    compra_id=row['compra_id'],
                    producto_id=row['producto_id'],
                    cantidad=row['cantidad'],
                    precio_unitario=row['precio_unitario']
                )
                
                detalle.producto = Producto(
                    id=row['producto_id'],
                    nombre=row['producto_nombre'],
                    referencia=row['producto_referencia']
                )
                
                detalles.append(detalle)
                
            return detalles

    def save(self):
        """
        Guarda o actualiza el detalle de compra en la base de datos.
        
        Returns:
            int: ID del detalle de compra
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            if self.id:
                # Actualizar detalle existente
                cursor.execute("""
                UPDATE compras_detalle SET
                    compra_id = ?,
                    producto_id = ?,
                    cantidad = ?,
                    precio_unitario = ?
                WHERE id = ?
                """, (self.compra_id, self.producto_id, self.cantidad, 
                      self.precio_unitario, self.id))
            else:
                # Crear nuevo detalle
                cursor.execute("""
                INSERT INTO compras_detalle (compra_id, producto_id, cantidad, precio_unitario)
                VALUES (?, ?, ?, ?)
                """, (self.compra_id, self.producto_id, self.cantidad, self.precio_unitario))
                self.id = cursor.lastrowid
                
                # Actualizar stock del producto
                cursor.execute("""
                UPDATE productos
                SET stock_actual = stock_actual + ?
                WHERE id = ?
                """, (self.cantidad, self.producto_id))
                
            return self.id

    @classmethod
    def buscar(cls, texto):
        """Busca usuarios por nombre de usuario o email."""
        with get_db() as conn:
            cursor = conn.cursor()
            query = """
                SELECT * FROM usuarios
                WHERE username LIKE ? OR email LIKE ?
                ORDER BY username
            """
            like_text = f"%{texto}%"
            cursor.execute(query, (like_text, like_text))
            return [
                cls(
                    id=row['id'],
                    username=row['username'],
                    email=row['email'],
                    password=row['password'],
                    es_admin=bool(row['es_admin']),
                    fecha_registro=row['fecha_registro']
                ) for row in cursor.fetchall()
            ]

    def delete(self):
        """Elimina el usuario de la base de datos."""
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute("DELETE FROM usuarios WHERE id = ?", (self.id,))
            return cursor.rowcount > 0


class Estadisticas:
    """
    Clase con métodos para obtener estadísticas del sistema.
    """

    @staticmethod
    def ventas_mensuales(dias=30, cliente_id=None):
        """
        Obtiene las ventas mensuales agrupadas por mes.
        
        Args:
            dias (int): Número de días a considerar
            cliente_id (int, optional): ID del cliente para filtrar
            
        Returns:
            list: Lista de diccionarios con mes y total
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT 
                strftime('%Y-%m', fecha) as mes,
                SUM(total) as total
            FROM ventas
            WHERE fecha >= datetime('now', ?)
            """
            
            params = [f'-{dias} days']
            
            if cliente_id:
                query += " AND cliente_id = ?"
                params.append(cliente_id)
                
            query += " GROUP BY mes ORDER BY mes"
            
            cursor.execute(query, params)
            
            return [{'mes': row['mes'], 'total': row['total']} for row in cursor.fetchall()]

    @staticmethod
    def productos_mas_vendidos(dias=30, cliente_id=None, limit=10):
        """
        Obtiene los productos más vendidos.
        
        Args:
            dias (int): Número de días a considerar
            cliente_id (int, optional): ID del cliente para filtrar
            limit (int): Número máximo de productos a devolver
            
        Returns:
            list: Lista de diccionarios con producto y cantidad
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT 
                p.nombre as producto,
                SUM(vd.cantidad) as cantidad
            FROM ventas_detalle vd
            JOIN ventas v ON vd.venta_id = v.id
            JOIN productos p ON vd.producto_id = p.id
            WHERE v.fecha >= datetime('now', ?)
            """
            
            params = [f'-{dias} days']
            
            if cliente_id:
                query += " AND v.cliente_id = ?"
                params.append(cliente_id)
                
            query += """
            GROUP BY vd.producto_id
            ORDER BY cantidad DESC
            LIMIT ?
            """
            params.append(limit)
            
            cursor.execute(query, params)
            
            return [{'producto': row['producto'], 'cantidad': row['cantidad']} 
                    for row in cursor.fetchall()]

    @staticmethod
    def beneficios_por_proveedor(dias=30, limit=10):
        """
        Obtiene los beneficios generados por proveedor.
        
        Args:
            dias (int): Número de días a considerar
            limit (int): Número máximo de proveedores a devolver
            
        Returns:
            list: Lista de diccionarios con proveedor y beneficio
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT 
                prov.nombre as proveedor,
                SUM((vd.precio_unitario - p.precio_compra) * vd.cantidad) as beneficio
            FROM ventas_detalle vd
            JOIN ventas v ON vd.venta_id = v.id
            JOIN productos p ON vd.producto_id = p.id
            JOIN proveedores prov ON p.proveedor_id = prov.id
            WHERE v.fecha >= datetime('now', ?)
            GROUP BY p.proveedor_id
            ORDER BY beneficio DESC
            LIMIT ?
            """
            
            cursor.execute(query, (f'-{dias} days', limit))
            
            return [{'proveedor': row['proveedor'], 'beneficio': row['beneficio']} 
                    for row in cursor.fetchall()]

    @staticmethod
    def stock_critico():
        """
        Obtiene los productos con stock crítico.
        
        Returns:
            list: Lista de diccionarios con información de stock
        """
        with get_db() as conn:
            cursor = conn.cursor()
            
            query = """
            SELECT 
                nombre as producto,
                stock_actual as actual,
                stock_minimo as minimo,
                CAST(stock_actual * 100.0 / stock_minimo as INT) as porcentaje
            FROM productos
            WHERE stock_actual <= stock_minimo AND stock_minimo > 0
            ORDER BY porcentaje
            """
            
            cursor.execute(query)
            
            return [dict(row) for row in cursor.fetchall()]