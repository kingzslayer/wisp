CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    thread TEXT UNIQUE NOT NULL,
    aura TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.bonds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    souls UUID[] NOT NULL,
    bonded_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE public.vibes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bond_id UUID NOT NULL REFERENCES public.bonds(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    mood TEXT NOT NULL,
    status TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE(bond_id, sender_id)
);

CREATE TABLE public.reaches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    soul_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    kindred_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE OR REPLACE FUNCTION public.update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_updated_at_users
    BEFORE UPDATE ON public.users
    FOR EACH ROW
    EXECUTE FUNCTION public.update_timestamp();

CREATE TRIGGER set_updated_at_vibes
    BEFORE UPDATE ON public.vibes
    FOR EACH ROW
    EXECUTE FUNCTION public.update_timestamp();

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bonds ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vibes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reaches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_read_all" ON public.users
    FOR SELECT USING (true);

CREATE POLICY "users_insert_own" ON public.users
    FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "users_update_own" ON public.users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "bonds_read_own" ON public.bonds
    FOR SELECT USING (auth.uid() = ANY (souls));

CREATE POLICY "bonds_insert_member" ON public.bonds
    FOR INSERT WITH CHECK (auth.uid() = ANY (souls));

CREATE POLICY "vibes_read_bond_member" ON public.vibes
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM bonds
            WHERE (bonds.id = vibes.bond_id) AND (auth.uid() = ANY (bonds.souls))
        )
    );

CREATE POLICY "vibes_insert_own" ON public.vibes
    FOR INSERT WITH CHECK (auth.uid() = sender_id);

CREATE POLICY "vibes_update_own" ON public.vibes
    FOR UPDATE USING (auth.uid() = sender_id);

CREATE POLICY "reaches_read_own" ON public.reaches
    FOR SELECT USING (auth.uid() = soul_id);

CREATE POLICY "Users can read reaches to them" ON public.reaches
    FOR SELECT USING (kindred_id = auth.uid());

CREATE POLICY "reaches_insert_own" ON public.reaches
    FOR INSERT WITH CHECK (auth.uid() = soul_id);

ALTER PUBLICATION supabase_realtime ADD TABLE public.vibes;
ALTER PUBLICATION supabase_realtime ADD TABLE public.bonds;
ALTER PUBLICATION supabase_realtime ADD TABLE public.reaches;
ALTER PUBLICATION supabase_realtime ADD TABLE public.users;
