/*
# Create firmas_compromiso and valoraciones tables

## Descripción
Crea las dos tablas que necesita la Estación de Valoración de Enfermería:
1. `firmas_compromiso` — registra la firma de compromiso de confidencialidad (Habeas Data) del usuario.
2. `valoraciones` — guarda las valoraciones clínicas de enfermería generadas por cada usuario.

## Tablas nuevas

### firmas_compromiso
- `id` (uuid, primary key)
- `user_id` (uuid, referencia a auth.users, defaults to auth.uid())
- `nombre_firmante` (text, nombre y legajo del firmante)
- `fecha_firma` (timestamptz, fecha de la firma)

### valoraciones
- `id` (uuid, primary key)
- `user_id` (uuid, referencia a auth.users, defaults to auth.uid())
- `paciente` (text, nombre del paciente)
- `edad` (text, edad con unidad)
- `fc` (text, frecuencia cardíaca)
- `ta` (text, tensión arterial)
- `temperatura` (text)
- `saturacion` (text, saturación de O2)
- `glasgow` (integer, escala de Glasgow)
- `observaciones` (text, narrativa clínica completa)
- `fecha` (timestamptz, fecha de la valoración)

## Seguridad (RLS)
- RLS habilitado en ambas tablas.
- Políticas de propietario: cada usuario autenticado solo puede leer, insertar, actualizar y eliminar sus propios registros.
- `user_id` tiene `DEFAULT auth.uid()` para que las inserciones funcionen correctamente.
*/

CREATE TABLE IF NOT EXISTS firmas_compromiso (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  nombre_firmante text NOT NULL,
  fecha_firma timestamptz DEFAULT now()
);

ALTER TABLE firmas_compromiso ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_firmas" ON firmas_compromiso;
CREATE POLICY "select_own_firmas" ON firmas_compromiso FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_firmas" ON firmas_compromiso;
CREATE POLICY "insert_own_firmas" ON firmas_compromiso FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_firmas" ON firmas_compromiso;
CREATE POLICY "update_own_firmas" ON firmas_compromiso FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_firmas" ON firmas_compromiso;
CREATE POLICY "delete_own_firmas" ON firmas_compromiso FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

CREATE TABLE IF NOT EXISTS valoraciones (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  paciente text,
  edad text,
  fc text,
  ta text,
  temperatura text,
  saturacion text,
  glasgow integer,
  observaciones text,
  fecha timestamptz DEFAULT now()
);

ALTER TABLE valoraciones ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_valoraciones" ON valoraciones;
CREATE POLICY "select_own_valoraciones" ON valoraciones FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_valoraciones" ON valoraciones;
CREATE POLICY "insert_own_valoraciones" ON valoraciones FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_valoraciones" ON valoraciones;
CREATE POLICY "update_own_valoraciones" ON valoraciones FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_valoraciones" ON valoraciones;
CREATE POLICY "delete_own_valoraciones" ON valoraciones FOR DELETE
  TO authenticated USING (auth.uid() = user_id);
