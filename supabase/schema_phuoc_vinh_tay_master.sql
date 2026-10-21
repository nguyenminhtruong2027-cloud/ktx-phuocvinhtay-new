-- ============================================================================
-- KTX MANAGER - COMPREHENSIVE SUPABASE DATABASE SETUP SCRIPT (ROBUST & IDEMPOTENT)
-- ============================================================================

-- 1. STORAGE BUCKET: worker-avatars (cho ảnh CCCD / avatar công nhân)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'worker-avatars',
  'worker-avatars',
  true,
  524288, -- 512KB max
  ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/gif']
)
ON CONFLICT (id) DO NOTHING;

DROP POLICY IF EXISTS "worker_avatars_public_read" ON storage.objects;
CREATE POLICY "worker_avatars_public_read" ON storage.objects FOR SELECT TO public USING (bucket_id = 'worker-avatars');

DROP POLICY IF EXISTS "worker_avatars_insert" ON storage.objects;
CREATE POLICY "worker_avatars_insert" ON storage.objects FOR INSERT TO public WITH CHECK (bucket_id = 'worker-avatars');

DROP POLICY IF EXISTS "worker_avatars_update" ON storage.objects;
CREATE POLICY "worker_avatars_update" ON storage.objects FOR UPDATE TO public USING (bucket_id = 'worker-avatars');

DROP POLICY IF EXISTS "worker_avatars_delete" ON storage.objects;
CREATE POLICY "worker_avatars_delete" ON storage.objects FOR DELETE TO public USING (bucket_id = 'worker-avatars');


-- ============================================================================
-- 2. TABLE: workers (Quản lý thông tin công nhân lưu trú)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.workers (
  id TEXT PRIMARY KEY,
  stt INTEGER DEFAULT 0,
  ho_va_ten TEXT NOT NULL DEFAULT '',
  ma_nv TEXT DEFAULT '',
  tieu_doan TEXT DEFAULT '',
  ktx TEXT DEFAULT '',
  don_vi TEXT DEFAULT '',
  gioi_tinh TEXT DEFAULT '',
  ngay_sinh TEXT DEFAULT '',
  so_dien_thoai TEXT DEFAULT '',
  day TEXT DEFAULT '',
  phong_so TEXT DEFAULT '',
  giuong TEXT DEFAULT '',
  cccd TEXT DEFAULT '',
  ho_khau_tinh TEXT DEFAULT '',
  to_truong TEXT DEFAULT '',
  sdt_to_truong TEXT DEFAULT '',
  ngay_vao_ktx TEXT DEFAULT '',
  ngay_ra_ktx TEXT DEFAULT '',
  ghi_chu TEXT DEFAULT '',
  khoa_tra_cuu TEXT DEFAULT '',
  avatar TEXT DEFAULT '',
  tam_tru_status TEXT DEFAULT 'unregistered',
  deleted_at TIMESTAMPTZ DEFAULT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- Ensure all required columns exist even if table was already created previously
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS stt INTEGER DEFAULT 0;
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ho_va_ten TEXT NOT NULL DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ma_nv TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS tieu_doan TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ktx TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS don_vi TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS gioi_tinh TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ngay_sinh TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS so_dien_thoai TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS day TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS phong_so TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS giuong TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS cccd TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ho_khau_tinh TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS to_truong TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS sdt_to_truong TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ngay_vao_ktx TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ngay_ra_ktx TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ghi_chu TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS khoa_tra_cuu TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS avatar TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS tam_tru_status TEXT DEFAULT 'unregistered';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ DEFAULT NULL;

-- English / mapped columns support
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS worker_code TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS full_name TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS id_card TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS phone TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS company TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS bed_id TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS status TEXT DEFAULT 'unregistered';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS gender TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS unit TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS battalion TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS birth_date TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS hometown TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS team_leader TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS team_leader_phone TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ktx_join_date TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS notes TEXT DEFAULT '';
ALTER TABLE public.workers ADD COLUMN IF NOT EXISTS ktx_block_id TEXT DEFAULT '';

CREATE INDEX IF NOT EXISTS idx_workers_day ON public.workers(day);
CREATE INDEX IF NOT EXISTS idx_workers_phong_so ON public.workers(phong_so);
CREATE INDEX IF NOT EXISTS idx_workers_ma_nv ON public.workers(ma_nv);
CREATE INDEX IF NOT EXISTS idx_workers_ho_va_ten ON public.workers(ho_va_ten);
CREATE INDEX IF NOT EXISTS idx_workers_stt ON public.workers(stt);
CREATE INDEX IF NOT EXISTS idx_workers_created_at ON public.workers(created_at);
CREATE INDEX IF NOT EXISTS idx_workers_deleted_at ON public.workers(deleted_at);
CREATE INDEX IF NOT EXISTS idx_workers_ktx ON public.workers(ktx);

ALTER TABLE public.workers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "authenticated_select_workers" ON public.workers;
CREATE POLICY "authenticated_select_workers" ON public.workers FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "authenticated_insert_workers" ON public.workers;
CREATE POLICY "authenticated_insert_workers" ON public.workers FOR INSERT TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "authenticated_update_workers" ON public.workers;
CREATE POLICY "authenticated_update_workers" ON public.workers FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "authenticated_delete_workers" ON public.workers;
CREATE POLICY "authenticated_delete_workers" ON public.workers FOR DELETE TO authenticated USING (true);

-- Anon access fallback for initial client connections
DROP POLICY IF EXISTS "anon_select_workers" ON public.workers;
CREATE POLICY "anon_select_workers" ON public.workers FOR SELECT TO anon USING (true);
DROP POLICY IF EXISTS "anon_insert_workers" ON public.workers;
CREATE POLICY "anon_insert_workers" ON public.workers FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_workers" ON public.workers;
CREATE POLICY "anon_update_workers" ON public.workers FOR UPDATE TO anon USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_workers" ON public.workers;
CREATE POLICY "anon_delete_workers" ON public.workers FOR DELETE TO anon USING (true);

CREATE OR REPLACE FUNCTION public.update_workers_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS workers_updated_at_trigger ON public.workers;
CREATE TRIGGER workers_updated_at_trigger
  BEFORE UPDATE ON public.workers
  FOR EACH ROW
  EXECUTE FUNCTION public.update_workers_updated_at();


-- ============================================================================
-- 3. TABLE: profiles (Quản lý phân quyền người dùng / nhân sự / admin)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT DEFAULT '',
  role TEXT NOT NULL DEFAULT 'staff' CHECK (role IN ('admin', 'staff')),
  assigned_blocks TEXT[] DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS email TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS full_name TEXT DEFAULT '';
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'staff';
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS assigned_blocks TEXT[] DEFAULT '{}';

COMMENT ON COLUMN public.profiles.assigned_blocks IS 'Array of KTX+Block combinations assigned to staff. Format: ["KTX 1 - Dãy A", "KTX 2 - Dãy B"].';

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE OR REPLACE FUNCTION public.is_admin_user()
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.profiles
    WHERE id = auth.uid()
    AND role = 'admin'
  )
$$;

CREATE OR REPLACE FUNCTION public.get_all_profiles()
RETURNS TABLE (
  id uuid,
  email text,
  full_name text,
  role text,
  assigned_blocks text[],
  created_at timestamptz
)
LANGUAGE plpgsql STABLE SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM public.profiles p
    WHERE p.id = auth.uid() AND p.role = 'admin'
  ) THEN
    RAISE EXCEPTION 'Access denied: Admin role required';
  END IF;

  RETURN QUERY
    SELECT
      p.id,
      p.email,
      p.full_name,
      p.role,
      COALESCE(p.assigned_blocks, '{}'::text[]) AS assigned_blocks,
      p.created_at
    FROM public.profiles p
    ORDER BY p.created_at DESC;
END;
$$;

DROP POLICY IF EXISTS "profiles_select_policy" ON public.profiles;
CREATE POLICY "profiles_select_policy" ON public.profiles FOR SELECT TO authenticated USING (auth.uid() = id OR public.is_admin_user());

DROP POLICY IF EXISTS "profiles_insert_policy" ON public.profiles;
CREATE POLICY "profiles_insert_policy" ON public.profiles FOR INSERT TO authenticated WITH CHECK (auth.uid() = id OR public.is_admin_user());

DROP POLICY IF EXISTS "profiles_update_policy" ON public.profiles;
CREATE POLICY "profiles_update_policy" ON public.profiles FOR UPDATE TO authenticated USING (auth.uid() = id OR public.is_admin_user()) WITH CHECK (auth.uid() = id OR public.is_admin_user());

DROP POLICY IF EXISTS "profiles_delete_policy" ON public.profiles;
CREATE POLICY "profiles_delete_policy" ON public.profiles FOR DELETE TO authenticated USING (public.is_admin_user());

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, role, assigned_blocks)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE(NEW.raw_user_meta_data->>'role', 'staff'),
    '{}'::text[]
  )
  ON CONFLICT (id) DO UPDATE
    SET
      email = EXCLUDED.email,
      full_name = COALESCE(EXCLUDED.full_name, public.profiles.full_name),
      role = COALESCE(EXCLUDED.role, public.profiles.role),
      updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.update_profiles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS profiles_updated_at ON public.profiles;
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.update_profiles_updated_at();


-- ============================================================================
-- 4. TABLE: facilities (Quản lý thiết bị / cơ sở vật chất phòng KTX)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.facilities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ktx TEXT NOT NULL DEFAULT '',
  day TEXT NOT NULL DEFAULT '',
  phong_khu_vuc TEXT NOT NULL DEFAULT '',
  giuong INTEGER NOT NULL DEFAULT 0,
  dieu_hoa INTEGER NOT NULL DEFAULT 0,
  tu INTEGER NOT NULL DEFAULT 0,
  quat INTEGER NOT NULL DEFAULT 0,
  o_cam_dien INTEGER NOT NULL DEFAULT 0,
  remote INTEGER NOT NULL DEFAULT 0,
  bong_tuyp INTEGER NOT NULL DEFAULT 0,
  ban_an INTEGER NOT NULL DEFAULT 0,
  ghe_an INTEGER NOT NULL DEFAULT 0,
  ghi_chu TEXT DEFAULT '',
  unit TEXT DEFAULT NULL,
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS ktx TEXT NOT NULL DEFAULT '';
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS day TEXT NOT NULL DEFAULT '';
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS phong_khu_vuc TEXT NOT NULL DEFAULT '';
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS giuong INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS dieu_hoa INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS tu INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS quat INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS o_cam_dien INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS remote INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS bong_tuyp INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS ban_an INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS ghe_an INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS ghi_chu TEXT DEFAULT '';
ALTER TABLE public.facilities ADD COLUMN IF NOT EXISTS unit TEXT DEFAULT NULL;

CREATE INDEX IF NOT EXISTS idx_facilities_ktx ON public.facilities(ktx);
CREATE INDEX IF NOT EXISTS idx_facilities_day ON public.facilities(day);
CREATE INDEX IF NOT EXISTS idx_facilities_phong ON public.facilities(phong_khu_vuc);

ALTER TABLE public.facilities ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "authenticated_read_facilities" ON public.facilities;
CREATE POLICY "authenticated_read_facilities" ON public.facilities FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "authenticated_insert_facilities" ON public.facilities;
CREATE POLICY "authenticated_insert_facilities" ON public.facilities FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "authenticated_update_facilities" ON public.facilities;
CREATE POLICY "authenticated_update_facilities" ON public.facilities FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "authenticated_delete_facilities" ON public.facilities;
CREATE POLICY "authenticated_delete_facilities" ON public.facilities FOR DELETE TO authenticated USING (true);

-- Anon access fallback for facilities
DROP POLICY IF EXISTS "anon_read_facilities" ON public.facilities;
CREATE POLICY "anon_read_facilities" ON public.facilities FOR SELECT TO anon USING (true);
DROP POLICY IF EXISTS "anon_insert_facilities" ON public.facilities;
CREATE POLICY "anon_insert_facilities" ON public.facilities FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_facilities" ON public.facilities;
CREATE POLICY "anon_update_facilities" ON public.facilities FOR UPDATE TO anon USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_facilities" ON public.facilities;
CREATE POLICY "anon_delete_facilities" ON public.facilities FOR DELETE TO anon USING (true);

CREATE OR REPLACE FUNCTION public.update_facilities_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS facilities_updated_at ON public.facilities;
CREATE TRIGGER facilities_updated_at
  BEFORE UPDATE ON public.facilities
  FOR EACH ROW
  EXECUTE FUNCTION public.update_facilities_updated_at();


-- ============================================================================
-- 5. TABLE: worker_registrations (Cổng đăng ký thông tin lưu trú qua QR code)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.worker_registrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ho_va_ten TEXT NOT NULL DEFAULT '',
  so_cccd TEXT NOT NULL DEFAULT '',
  so_dien_thoai TEXT NOT NULL DEFAULT '',
  ngay_sinh TEXT NOT NULL DEFAULT '',
  que_quan TEXT NOT NULL DEFAULT '',
  ktx TEXT NOT NULL DEFAULT '',
  day TEXT NOT NULL DEFAULT '',
  phong_so TEXT NOT NULL DEFAULT '',
  cccd_image_url TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  reviewed_by UUID,
  reviewed_at TIMESTAMPTZ,
  ghi_chu TEXT DEFAULT '',
  ma_nv TEXT DEFAULT '',
  gioi_tinh TEXT DEFAULT '',
  don_vi TEXT DEFAULT '',
  tieu_doan TEXT DEFAULT '',
  to_truong TEXT DEFAULT '',
  sdt_to_truong TEXT DEFAULT '',
  ho_khau_tinh TEXT DEFAULT '',
  giuong TEXT DEFAULT '',
  ngay_vao_ktx TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS ho_va_ten TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS so_cccd TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS so_dien_thoai TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS ngay_sinh TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS que_quan TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS ktx TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS day TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS phong_so TEXT NOT NULL DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS cccd_image_url TEXT;
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS status TEXT NOT NULL DEFAULT 'pending';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS reviewed_by UUID;
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS reviewed_at TIMESTAMPTZ;
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS ghi_chu TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS ma_nv TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS gioi_tinh TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS don_vi TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS tieu_doan TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS to_truong TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS sdt_to_truong TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS ho_khau_tinh TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS giuong TEXT DEFAULT '';
ALTER TABLE public.worker_registrations ADD COLUMN IF NOT EXISTS ngay_vao_ktx TEXT DEFAULT '';

CREATE INDEX IF NOT EXISTS idx_worker_registrations_status ON public.worker_registrations(status);
CREATE INDEX IF NOT EXISTS idx_worker_registrations_created_at ON public.worker_registrations(created_at DESC);

ALTER TABLE public.worker_registrations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_can_submit_registration" ON public.worker_registrations;
CREATE POLICY "public_can_submit_registration" ON public.worker_registrations FOR INSERT TO public WITH CHECK (true);

DROP POLICY IF EXISTS "authenticated_can_read_registrations" ON public.worker_registrations;
CREATE POLICY "authenticated_can_read_registrations" ON public.worker_registrations FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "authenticated_can_update_registrations" ON public.worker_registrations;
CREATE POLICY "authenticated_can_update_registrations" ON public.worker_registrations FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "authenticated_can_delete_registrations" ON public.worker_registrations;
CREATE POLICY "authenticated_can_delete_registrations" ON public.worker_registrations FOR DELETE TO authenticated USING (true);


-- ============================================================================
-- 6. TABLE: audit_logs (Lịch sử thao tác hệ thống / Nhật ký kiểm toán)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  account TEXT NOT NULL,
  action TEXT NOT NULL,
  detail TEXT NOT NULL DEFAULT ''
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON public.audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_account ON public.audit_logs(account);

ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "admins_read_audit_logs" ON public.audit_logs;
CREATE POLICY "admins_read_audit_logs" ON public.audit_logs FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "admins_insert_audit_logs" ON public.audit_logs;
CREATE POLICY "admins_insert_audit_logs" ON public.audit_logs FOR INSERT TO authenticated WITH CHECK (true);

DROP POLICY IF EXISTS "anon_read_audit_logs" ON public.audit_logs;
CREATE POLICY "anon_read_audit_logs" ON public.audit_logs FOR SELECT TO anon USING (true);

DROP POLICY IF EXISTS "anon_insert_audit_logs" ON public.audit_logs;
CREATE POLICY "anon_insert_audit_logs" ON public.audit_logs FOR INSERT TO anon WITH CHECK (true);


-- ============================================================================
-- 7. TABLE: room_units & room_unit_assignments (Quản lý đơn vị quản lý / gán phòng)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.room_units (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  ktx text NOT NULL,
  day_nha text NOT NULL,
  phong_so text NOT NULL,
  unit text NOT NULL,
  room_label text,
  room_note text DEFAULT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  CONSTRAINT room_units_ktx_day_nha_phong_so_key UNIQUE (ktx, day_nha, phong_so)
);

ALTER TABLE public.room_units ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "anon_select_room_units" ON public.room_units;
CREATE POLICY "anon_select_room_units" ON public.room_units FOR SELECT TO anon USING (true);
DROP POLICY IF EXISTS "anon_insert_room_units" ON public.room_units;
CREATE POLICY "anon_insert_room_units" ON public.room_units FOR INSERT TO anon WITH CHECK (true);
DROP POLICY IF EXISTS "anon_update_room_units" ON public.room_units;
CREATE POLICY "anon_update_room_units" ON public.room_units FOR UPDATE TO anon USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "anon_delete_room_units" ON public.room_units;
CREATE POLICY "anon_delete_room_units" ON public.room_units FOR DELETE TO anon USING (true);

DROP POLICY IF EXISTS "authenticated_select_room_units" ON public.room_units;
CREATE POLICY "authenticated_select_room_units" ON public.room_units FOR SELECT TO authenticated USING (true);
DROP POLICY IF EXISTS "authenticated_insert_room_units" ON public.room_units;
CREATE POLICY "authenticated_insert_room_units" ON public.room_units FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "authenticated_update_room_units" ON public.room_units;
CREATE POLICY "authenticated_update_room_units" ON public.room_units FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "authenticated_delete_room_units" ON public.room_units;
CREATE POLICY "authenticated_delete_room_units" ON public.room_units FOR DELETE TO authenticated USING (true);


-- ============================================================================
-- 8. TABLE: worker_deletion_log (Lịch sử xóa công nhân phục vụ báo cáo biến động)
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.worker_deletion_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  worker_id TEXT NOT NULL,
  ho_va_ten TEXT,
  ma_nv TEXT,
  ktx TEXT,
  day TEXT,
  deleted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_worker_deletion_log_deleted_at ON public.worker_deletion_log(deleted_at);
CREATE INDEX IF NOT EXISTS idx_worker_deletion_log_ktx ON public.worker_deletion_log(ktx);
CREATE INDEX IF NOT EXISTS idx_worker_deletion_log_day ON public.worker_deletion_log(day);

ALTER TABLE public.worker_deletion_log ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "authenticated_manage_worker_deletion_log" ON public.worker_deletion_log;
CREATE POLICY "authenticated_manage_worker_deletion_log" ON public.worker_deletion_log FOR ALL TO authenticated USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "anon_manage_worker_deletion_log" ON public.worker_deletion_log;
CREATE POLICY "anon_manage_worker_deletion_log" ON public.worker_deletion_log FOR ALL TO anon USING (true) WITH CHECK (true);


-- ============================================================================
-- 9. RPC FUNCTIONS: Thống kê biến động nhân sự (Tăng / Giảm / Biến động ròng)
-- ============================================================================
CREATE OR REPLACE FUNCTION public.get_worker_fluctuation(
  p_date_from   DATE    DEFAULT NULL,
  p_date_to     DATE    DEFAULT NULL,
  p_ktx         TEXT    DEFAULT NULL,
  p_day         TEXT    DEFAULT NULL,
  p_cutoff_hour INTEGER DEFAULT 14
)
RETURNS TABLE(
  ngay           DATE,
  so_tang        BIGINT,
  so_giam        BIGINT,
  bien_dong_rong BIGINT
)
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_tz TEXT := 'Asia/Ho_Chi_Minh';
BEGIN
  RETURN QUERY
  WITH date_series AS (
    SELECT generate_series(
      COALESCE(p_date_from, (CURRENT_TIMESTAMP AT TIME ZONE v_tz)::DATE - INTERVAL '29 days'),
      COALESCE(p_date_to,   (CURRENT_TIMESTAMP AT TIME ZONE v_tz)::DATE),
      INTERVAL '1 day'
    )::DATE AS d
  ),
  additions AS (
    SELECT
      (created_at AT TIME ZONE v_tz)::DATE AS ngay_them,
      COUNT(*) AS cnt
    FROM public.workers
    WHERE
      (p_ktx IS NULL OR ktx = p_ktx)
      AND (p_day IS NULL OR day = p_day)
      AND (p_date_from IS NULL OR (created_at AT TIME ZONE v_tz)::DATE >= p_date_from)
      AND (p_date_to   IS NULL OR (created_at AT TIME ZONE v_tz)::DATE <= p_date_to)
      AND (
        p_cutoff_hour = -1
        OR EXTRACT(HOUR FROM (created_at AT TIME ZONE v_tz)) < p_cutoff_hour
        OR (created_at AT TIME ZONE v_tz)::DATE < (CURRENT_TIMESTAMP AT TIME ZONE v_tz)::DATE
      )
    GROUP BY 1
  ),
  removals AS (
    SELECT
      (deleted_at AT TIME ZONE v_tz)::DATE AS ngay_xoa,
      COUNT(*) AS cnt
    FROM public.worker_deletion_log
    WHERE
      (p_ktx IS NULL OR ktx = p_ktx)
      AND (p_day IS NULL OR day = p_day)
      AND (p_date_from IS NULL OR (deleted_at AT TIME ZONE v_tz)::DATE >= p_date_from)
      AND (p_date_to   IS NULL OR (deleted_at AT TIME ZONE v_tz)::DATE <= p_date_to)
      AND (
        p_cutoff_hour = -1
        OR EXTRACT(HOUR FROM (deleted_at AT TIME ZONE v_tz)) < p_cutoff_hour
        OR (deleted_at AT TIME ZONE v_tz)::DATE < (CURRENT_TIMESTAMP AT TIME ZONE v_tz)::DATE
      )
    GROUP BY 1
  )
  SELECT
    ds.d                                         AS ngay,
    COALESCE(a.cnt, 0)                           AS so_tang,
    COALESCE(r.cnt, 0)                           AS so_giam,
    COALESCE(a.cnt, 0) - COALESCE(r.cnt, 0)      AS bien_dong_rong
  FROM date_series ds
  LEFT JOIN additions a ON a.ngay_them = ds.d
  LEFT JOIN removals  r ON r.ngay_xoa  = ds.d
  WHERE COALESCE(a.cnt, 0) > 0 OR COALESCE(r.cnt, 0) > 0
  ORDER BY ds.d;
END;
$$;

CREATE OR REPLACE FUNCTION public.get_worker_fluctuation_summary(
  p_date_from   DATE    DEFAULT NULL,
  p_date_to     DATE    DEFAULT NULL,
  p_ktx         TEXT    DEFAULT NULL,
  p_day         TEXT    DEFAULT NULL,
  p_cutoff_hour INTEGER DEFAULT 14
)
RETURNS TABLE(
  tong_tang            BIGINT,
  tong_giam            BIGINT,
  bien_dong_rong       BIGINT,
  so_ngay_co_bien_dong BIGINT
)
LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  v_tz   TEXT   := 'Asia/Ho_Chi_Minh';
  v_tang BIGINT;
  v_giam BIGINT;
BEGIN
  SELECT COUNT(*) INTO v_tang
  FROM public.workers
  WHERE
    (p_ktx IS NULL OR ktx = p_ktx)
    AND (p_day IS NULL OR day = p_day)
    AND (p_date_from IS NULL OR (created_at AT TIME ZONE v_tz)::DATE >= p_date_from)
    AND (p_date_to   IS NULL OR (created_at AT TIME ZONE v_tz)::DATE <= p_date_to)
    AND (
      p_cutoff_hour = -1
      OR EXTRACT(HOUR FROM (created_at AT TIME ZONE v_tz)) < p_cutoff_hour
      OR (created_at AT TIME ZONE v_tz)::DATE < (CURRENT_TIMESTAMP AT TIME ZONE v_tz)::DATE
    );

  SELECT COUNT(*) INTO v_giam
  FROM public.worker_deletion_log
  WHERE
    (p_ktx IS NULL OR ktx = p_ktx)
    AND (p_day IS NULL OR day = p_day)
    AND (p_date_from IS NULL OR (deleted_at AT TIME ZONE v_tz)::DATE >= p_date_from)
    AND (p_date_to   IS NULL OR (deleted_at AT TIME ZONE v_tz)::DATE <= p_date_to)
    AND (
      p_cutoff_hour = -1
      OR EXTRACT(HOUR FROM (deleted_at AT TIME ZONE v_tz)) < p_cutoff_hour
      OR (deleted_at AT TIME ZONE v_tz)::DATE < (CURRENT_TIMESTAMP AT TIME ZONE v_tz)::DATE
    );

  RETURN QUERY
  SELECT
    v_tang                AS tong_tang,
    v_giam                AS tong_giam,
    (v_tang - v_giam)     AS bien_dong_rong,
    (
      SELECT COUNT(DISTINCT ngay) FROM (
        SELECT (created_at AT TIME ZONE v_tz)::DATE AS ngay
        FROM public.workers
        WHERE
          (p_ktx IS NULL OR ktx = p_ktx)
          AND (p_day IS NULL OR day = p_day)
          AND (p_date_from IS NULL OR (created_at AT TIME ZONE v_tz)::DATE >= p_date_from)
          AND (p_date_to   IS NULL OR (created_at AT TIME ZONE v_tz)::DATE <= p_date_to)
        UNION ALL
        SELECT (deleted_at AT TIME ZONE v_tz)::DATE AS ngay
        FROM public.worker_deletion_log
        WHERE
          (p_ktx IS NULL OR ktx = p_ktx)
          AND (p_day IS NULL OR day = p_day)
          AND (p_date_from IS NULL OR (deleted_at AT TIME ZONE v_tz)::DATE >= p_date_from)
          AND (p_date_to   IS NULL OR (deleted_at AT TIME ZONE v_tz)::DATE <= p_date_to)
      ) sub
    )::BIGINT             AS so_ngay_co_bien_dong;
END;
$$;


-- ============================================================================
-- 10. ATTENDANCE MODULE: Quản lý điểm danh QR code theo ngày và khu vực
-- ============================================================================
CREATE TABLE IF NOT EXISTS public.attendance_sessions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_date  DATE NOT NULL,
  opened_by     UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  opened_at     TIMESTAMPTZ DEFAULT now(),
  is_active     BOOLEAN DEFAULT true,
  zone_ktx      TEXT DEFAULT '',
  zone_day      TEXT DEFAULT '',
  zone_phong    TEXT DEFAULT '',
  created_at    TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_attendance_sessions_date_zone
  ON public.attendance_sessions (session_date, zone_ktx, zone_day, zone_phong);

CREATE TABLE IF NOT EXISTS public.attendance_records (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id    UUID NOT NULL REFERENCES public.attendance_sessions(id) ON DELETE CASCADE,
  session_date  DATE NOT NULL,
  ma_nv         TEXT NOT NULL,
  ho_va_ten     TEXT NOT NULL,
  ktx           TEXT DEFAULT '',
  day           TEXT DEFAULT '',
  phong_so      TEXT DEFAULT '',
  checked_in_at TIMESTAMPTZ DEFAULT now(),
  status        TEXT DEFAULT 'present',
  ghi_chu       TEXT DEFAULT '',
  created_at    TIMESTAMPTZ DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_attendance_records_session_manv
  ON public.attendance_records (session_id, ma_nv);
CREATE INDEX IF NOT EXISTS idx_attendance_records_session_id
  ON public.attendance_records (session_id);
CREATE INDEX IF NOT EXISTS idx_attendance_records_session_date
  ON public.attendance_records (session_date);

ALTER TABLE public.attendance_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records  ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "attendance_sessions_select" ON public.attendance_sessions;
CREATE POLICY "attendance_sessions_select" ON public.attendance_sessions FOR SELECT TO authenticated, anon USING (true);
DROP POLICY IF EXISTS "attendance_sessions_insert" ON public.attendance_sessions;
CREATE POLICY "attendance_sessions_insert" ON public.attendance_sessions FOR INSERT TO authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "attendance_sessions_update" ON public.attendance_sessions;
CREATE POLICY "attendance_sessions_update" ON public.attendance_sessions FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "attendance_sessions_delete" ON public.attendance_sessions;
CREATE POLICY "attendance_sessions_delete" ON public.attendance_sessions FOR DELETE TO authenticated USING (true);

DROP POLICY IF EXISTS "attendance_records_select" ON public.attendance_records;
CREATE POLICY "attendance_records_select" ON public.attendance_records FOR SELECT TO authenticated, anon USING (true);
DROP POLICY IF EXISTS "attendance_records_insert_public" ON public.attendance_records;
CREATE POLICY "attendance_records_insert_public" ON public.attendance_records FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "attendance_records_update" ON public.attendance_records;
CREATE POLICY "attendance_records_update" ON public.attendance_records FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "attendance_records_delete" ON public.attendance_records;
CREATE POLICY "attendance_records_delete" ON public.attendance_records FOR DELETE TO authenticated USING (true);

-- ============================================================================
-- HOÀN TẤT THIẾT LẬP DATABASE
-- ============================================================================
