"""
Módulo para gestionar la conexión a la base de datos.

Este módulo proporciona funciones para crear una conexión a la base de datos SQLite,
inicializar tablas y gestionar la sesión de base de datos.

"""

import sqlite3
import os
from contextlib import contextmanager

# Ruta del directorio de la base de datos
DB_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'database')
DB_PATH = os.path.join(DB_DIR, 'store_componentes.db')
SQL_PATH = os.path.join(DB_DIR, 'store_componentes.sql')


def crear_directorio_db():
    """
    Crea el directorio de la base de datos si no existe.
    """
    if not os.path.exists(DB_DIR):
        os.makedirs(DB_DIR)


def get_db_connection():
    """
    Establece una conexión con la base de datos SQLite.

    Returns:
        sqlite3.Connection: Objeto de conexión a la base de datos
    """
    crear_directorio_db()
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row  # Para acceder a las columnas por nombre
    return conn


@contextmanager
def get_db():
    """
    Context manager para gestionar la conexión a la base de datos.

    Yields:
        sqlite3.Connection: Objeto de conexión a la base de datos
    """
    conn = get_db_connection()
    try:
        yield conn
        conn.commit()
    except Exception as e:
        conn.rollback()
        raise e
    finally:
        conn.close()


def inicializar_db():
    """
    Inicializa la base de datos creando todas las tablas necesarias
    si no existen.
    """
    crear_directorio_db()

    # Verificar si la base de datos existe y tiene tablas
    db_existe = os.path.exists(DB_PATH) and os.path.getsize(DB_PATH) > 0

    with get_db() as conn:
        cursor = conn.cursor()

        if not db_existe:
            print("Base de datos no encontrada o vacía. Inicializando...")

            # Verificar si existe el script SQL
            if os.path.exists(SQL_PATH):
                print(f"Ejecutando script SQL desde: {SQL_PATH}")
                with open(SQL_PATH, 'r', encoding='utf-8') as sql_file:
                    sql_script = sql_file.read()

                # Ejecutar el script SQL
                cursor.executescript(sql_script)
                print("Base de datos inicializada correctamente desde script SQL.")
            else:
                print("Script SQL no encontrado. Se inicializarán las tablas manualmente.")
                # Crear las tablas manualmente
                crear_tablas_manualmente(cursor)
        else:
            # Comprobar si hay tablas
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
            tablas = cursor.fetchall()
            if not tablas:
                # La base de datos existe pero está vacía
                if os.path.exists(SQL_PATH):
                    print(f"Base de datos vacía. Ejecutando script SQL desde: {SQL_PATH}")
                    with open(SQL_PATH, 'r', encoding='utf-8') as sql_file:
                        sql_script = sql_file.read()

                    # Ejecutar el script SQL
                    cursor.executescript(sql_script)
                    print("Base de datos inicializada correctamente desde script SQL.")
                else:
                    print("Script SQL no encontrado. Se inicializarán las tablas manualmente.")
                    crear_tablas_manualmente(cursor)
            else:
                print(f"Base de datos encontrada con {len(tablas)} tablas.")


def crear_tablas_manualmente(cursor):
    """
    Crea las tablas de la base de datos manualmente.

    Args:
        cursor: Cursor de la conexión a la base de datos
    """
    # Crear tabla de usuarios
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            es_admin BOOLEAN DEFAULT 0,
            fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')

    # Crear tabla de proveedores
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS proveedores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        cif TEXT UNIQUE NOT NULL,
        direccion TEXT,
        telefono TEXT,
        email TEXT,
        porcentaje_descuento REAL DEFAULT 0,
        iva REAL DEFAULT 21,
        notas TEXT
    )
    ''')

    # Crear tabla de productos
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        referencia TEXT UNIQUE NOT NULL,
        descripcion TEXT,
        precio_compra REAL NOT NULL,
        precio_venta REAL NOT NULL,
        stock_actual INTEGER DEFAULT 0,
        stock_minimo INTEGER DEFAULT 0,
        ubicacion_almacen TEXT,
        categoria TEXT,
        imagen TEXT,
        proveedor_id INTEGER,
        FOREIGN KEY (proveedor_id) REFERENCES proveedores (id)
    )
    ''')

    # Crear tabla de ventas (pedidos de clientes)
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS ventas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER NOT NULL,
        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        total REAL DEFAULT 0,
        FOREIGN KEY (cliente_id) REFERENCES usuarios (id)
    )
    ''')

    # Crear tabla de detalle de ventas
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS ventas_detalle (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        venta_id INTEGER NOT NULL,
        producto_id INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        precio_unitario REAL NOT NULL,
        FOREIGN KEY (venta_id) REFERENCES ventas (id),
        FOREIGN KEY (producto_id) REFERENCES productos (id)
    )
    ''')

    # Crear tabla de compras (a proveedores)
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS compras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        proveedor_id INTEGER NOT NULL,
        fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        total REAL DEFAULT 0,
        FOREIGN KEY (proveedor_id) REFERENCES proveedores (id)
    )
    ''')

    # Crear tabla de detalle de compras
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS compras_detalle (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        compra_id INTEGER NOT NULL,
        producto_id INTEGER NOT NULL,
        cantidad INTEGER NOT NULL,
        precio_unitario REAL NOT NULL,
        FOREIGN KEY (compra_id) REFERENCES compras (id),
        FOREIGN KEY (producto_id) REFERENCES productos (id)
    )
    ''')

    print("Base de datos inicializada manualmente correctamente.")