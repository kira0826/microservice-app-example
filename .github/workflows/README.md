### 🚀 **Explicación del Código `Set matrix` en GitHub Actions**  

Este bloque de código genera una **matriz (`matrix`) dinámica** para ejecutar tareas solo en los servicios que han cambiado en un push o PR. Esto optimiza los jobs en GitHub Actions, evitando builds innecesarios.

---

## 🔍 **Análisis Línea por Línea**
```yaml
- name: Set matrix
  id: set-matrix
  run: |
```
- Define un **paso (step)** en GitHub Actions llamado `Set matrix`.  
- Se le asigna un `id` (`set-matrix`) para que otros pasos puedan referenciar su salida.  
- Ejecuta un **script Bash** (`run: |`).

---

### **1️⃣ Inicialización de la Matriz**
```bash
SERVICES="["
```
- Se inicializa una variable `SERVICES` como un array JSON vacío.

---

### **2️⃣ Verificación de Archivos Cambiados**
Cada `if` verifica si un servicio ha cambiado usando:  
```yaml
${{ contains(steps.changed-files.outputs.all_changed_files, 'auth-api/') }}
```
Esto:
- Usa `${{ contains(...) }}` para comprobar si `auth-api/` aparece en la lista de archivos cambiados (`all_changed_files`).
- Si es `true`, añade un objeto JSON con datos del servicio.

Ejemplo de un servicio:
```bash
if [[ ${{ contains(steps.changed-files.outputs.all_changed_files, 'auth-api/') }} == true ]]; then
  SERVICES="$SERVICES{\"service\":\"auth-api\",\"type\":\"backend\",\"context\":\"./auth-api\",\"version\":\"$(cat auth-api/VERSION)\"},"
fi
```
📌 **Lo que hace:**
- Si hubo cambios en `auth-api/`:
  - Agrega un objeto con:
    - `"service": "auth-api"` → Nombre del microservicio.
    - `"type": "backend"` → Tipo (puede ser `backend` o `frontend`).
    - `"context": "./auth-api"` → Ruta del código fuente.
    - `"version": "$(cat auth-api/VERSION)"` → Obtiene la versión actual.

---

### **3️⃣ Cierre del Array JSON**
```bash
SERVICES="${SERVICES%,}]"
```
📌 **Lo que hace:**
- Elimina la **última coma `,`** para evitar errores de formato en JSON.
- Cierra el array con `]`.

---

### **4️⃣ Guardar la Matriz en `GITHUB_OUTPUT`**
```bash
echo "matrix={\"include\":$SERVICES}" >> $GITHUB_OUTPUT
```
📌 **Lo que hace:**
- Crea una salida (`matrix`) con la matriz JSON final.
- GitHub Actions la usará en la estrategia de `matrix`.

---

## 🛠 **Ejemplo de Matriz Resultante (`matrix`)**  
Si **solo `auth-api/` y `users-api/` cambiaron**, la salida será:

```json
{
  "include": [
    {
      "service": "auth-api",
      "type": "backend",
      "context": "./auth-api",
      "version": "v1.2.3"
    },
    {
      "service": "users-api",
      "type": "backend",
      "context": "./users-api",
      "version": "v2.0.1"
    }
  ]
}
```

---

## 🎯 **Cómo Se Usa la Matriz**
En un `jobs` que construye imágenes Docker por cada microservicio cambiado:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix: ${{ fromJson(steps.set-matrix.outputs.matrix) }}
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build and Push Docker Image
        run: |
          docker build -t ghcr.io/YOURNAME/${{ matrix.service }}:${{ matrix.version }} ${{ matrix.context }}
          docker push ghcr.io/YOURNAME/${{ matrix.service }}:${{ matrix.version }}
```
📌 **Lo que hace:**
- GitHub ejecuta un **job por cada servicio que cambió**.
- Usa `matrix.service`, `matrix.version` y `matrix.context` en el build de Docker.

---

## ✅ **Resumen**
1. **Detecta qué microservicios cambiaron** en el push o PR.
2. **Construye una matriz JSON dinámica** con los servicios modificados.
3. **Usa `matrix` para ejecutar builds solo en esos servicios**, optimizando CI/CD.

Así evitas recompilar microservicios innecesariamente. 🚀🔥