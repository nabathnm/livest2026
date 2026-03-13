-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.cart_items (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  product_id smallint,
  CONSTRAINT cart_items_pkey PRIMARY KEY (id),
  CONSTRAINT cart_items_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id),
  CONSTRAINT cart_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id)
);
CREATE TABLE public.education_categories (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  name text,
  CONSTRAINT education_categories_pkey PRIMARY KEY (id)
);
CREATE TABLE public.educations (
  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  title text,
  description text,
  imageUrl text DEFAULT 'https://kktruowghwbltqrwcden.supabase.co/storage/v1/object/public/educationImage/thumbnail.jpg'::text,
  categories smallint,
  CONSTRAINT educations_pkey PRIMARY KEY (id),
  CONSTRAINT educations_categories_fkey FOREIGN KEY (categories) REFERENCES public.education_categories(id)
);
CREATE TABLE public.products (
  id smallint GENERATED ALWAYS AS IDENTITY NOT NULL,
  user_id uuid NOT NULL,
  image_url text,
  name text,
  description text,
  price integer DEFAULT 0,
  is_sold boolean DEFAULT false,
  type text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  location text,
  phone text,
  farm_name text,
  breader_name text,
  CONSTRAINT products_pkey PRIMARY KEY (id),
  CONSTRAINT products_breader_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL,
  full_name text,
  role text CHECK (role = ANY (ARRAY['peternak'::text, 'pembeli'::text])),
  farm_name text,
  farm_location text,
  animal_types text,
  preferences text,
  updated_at timestamp with time zone NOT NULL DEFAULT timezone('utc'::text, now()),
  description text,
  email text,
  phone_number text,
  is_deleted boolean DEFAULT false,
  deleted_at timestamp with time zone,
  avatar_url text,
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);