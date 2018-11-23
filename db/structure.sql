--
-- PostgreSQL database dump
--

-- Dumped from database version 10.5
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id integer NOT NULL,
    action character varying(255),
    number integer,
    owner_type character varying(255),
    owner_id integer,
    actor_type character varying(255),
    actor_id integer,
    item_type character varying(255),
    item_id integer,
    info text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    session_key character varying(255)
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: answer_taxons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answer_taxons (
    id integer NOT NULL,
    answer_id integer,
    taxon_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: answer_taxons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.answer_taxons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answer_taxons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.answer_taxons_id_seq OWNED BY public.answer_taxons.id;


--
-- Name: answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answers (
    id integer NOT NULL,
    question_id integer,
    code character varying(255),
    glam integer,
    girly integer,
    classic integer,
    edgy integer,
    bohemian integer,
    sexiness integer,
    fashionability integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.answers_id_seq OWNED BY public.answers.id;


--
-- Name: batch_collection_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_collection_line_items (
    id integer NOT NULL,
    batch_collection_id integer,
    line_item_id integer,
    projected_delivery_date timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: batch_collection_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.batch_collection_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: batch_collection_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.batch_collection_line_items_id_seq OWNED BY public.batch_collection_line_items.id;


--
-- Name: batch_collections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.batch_collections (
    id integer NOT NULL,
    batch_key character varying(255),
    status character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: batch_collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.batch_collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: batch_collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.batch_collections_id_seq OWNED BY public.batch_collections.id;


--
-- Name: bergen_return_item_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bergen_return_item_processes (
    id integer NOT NULL,
    aasm_state character varying(255),
    return_request_item_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    failed boolean DEFAULT false,
    sentry_id character varying(255)
);


--
-- Name: bergen_return_item_processes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bergen_return_item_processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bergen_return_item_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bergen_return_item_processes_id_seq OWNED BY public.bergen_return_item_processes.id;


--
-- Name: bulk_order_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bulk_order_updates (
    id integer NOT NULL,
    "user" text,
    filename text,
    processed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: bulk_order_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bulk_order_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bulk_order_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bulk_order_updates_id_seq OWNED BY public.bulk_order_updates.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    category character varying(255),
    subcategory character varying(255)
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: celebrity_inspirations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.celebrity_inspirations (
    id integer NOT NULL,
    spree_product_id integer,
    celebrity_name character varying(255),
    photo_file_name character varying(255),
    photo_content_type character varying(255),
    photo_file_size integer,
    photo_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    celebrity_description text
);


--
-- Name: celebrity_inspirations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.celebrity_inspirations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: celebrity_inspirations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.celebrity_inspirations_id_seq OWNED BY public.celebrity_inspirations.id;


--
-- Name: competition_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.competition_entries (
    id integer NOT NULL,
    user_id integer,
    inviter_id integer,
    invitation_id integer,
    master boolean DEFAULT false,
    created_at timestamp without time zone,
    competition_name character varying(255),
    competition_id integer
);


--
-- Name: competition_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.competition_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competition_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.competition_entries_id_seq OWNED BY public.competition_entries.id;


--
-- Name: competition_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.competition_invitations (
    id integer NOT NULL,
    user_id integer,
    token character varying(50),
    email character varying(255),
    name character varying(255),
    invitation_type character varying(50),
    created_at timestamp without time zone,
    competition_name character varying(255),
    competition_id integer
);


--
-- Name: competition_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.competition_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competition_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.competition_invitations_id_seq OWNED BY public.competition_invitations.id;


--
-- Name: competition_participations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.competition_participations (
    id integer NOT NULL,
    spree_user_id integer,
    token character varying(255),
    shares_count integer DEFAULT 0,
    views_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: competition_participations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.competition_participations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competition_participations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.competition_participations_id_seq OWNED BY public.competition_participations.id;


--
-- Name: contentful_routes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contentful_routes (
    id integer NOT NULL,
    route_name character varying(255),
    controller character varying(255),
    action character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contentful_routes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contentful_routes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contentful_routes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contentful_routes_id_seq OWNED BY public.contentful_routes.id;


--
-- Name: contentful_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contentful_versions (
    id integer NOT NULL,
    change_message character varying(255),
    payload text,
    user_id integer,
    is_live boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contentful_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contentful_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contentful_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contentful_versions_id_seq OWNED BY public.contentful_versions.id;


--
-- Name: curations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.curations (
    id integer NOT NULL,
    name character varying(255),
    pid character varying(255),
    product_id integer,
    active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: curations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.curations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: curations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.curations_id_seq OWNED BY public.curations.id;


--
-- Name: curations_taxons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.curations_taxons (
    curation_id integer,
    taxon_id integer
);


--
-- Name: custom_dress_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_dress_images (
    id integer NOT NULL,
    custom_dress_id integer,
    file_file_name character varying(255),
    file_content_type character varying(255),
    file_file_size integer,
    file_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_dress_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_dress_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_dress_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_dress_images_id_seq OWNED BY public.custom_dress_images.id;


--
-- Name: custom_dresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_dresses (
    id integer NOT NULL,
    description text,
    color character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    spree_user_id integer,
    phone_number character varying(255),
    size character varying(255),
    ghost boolean DEFAULT true,
    required_at date,
    school_name character varying(255)
);


--
-- Name: custom_dresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.custom_dresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_dresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.custom_dresses_id_seq OWNED BY public.custom_dresses.id;


--
-- Name: customisation_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customisation_values (
    id integer NOT NULL,
    "position" integer,
    name character varying(255),
    presentation character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    price numeric(8,2),
    product_id integer,
    customisation_type character varying(255) DEFAULT 'cut'::character varying,
    point_of_view character varying(255) DEFAULT 'front'::character varying
);


--
-- Name: customisation_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customisation_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customisation_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customisation_values_id_seq OWNED BY public.customisation_values.id;


--
-- Name: customization_visualizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customization_visualizations (
    id integer NOT NULL,
    customization_ids character varying(1024),
    incompatible_ids character varying(1024),
    render_urls jsonb,
    product_id integer,
    length character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    silhouette character varying(255),
    neckline character varying(255)
);


--
-- Name: customization_visualizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customization_visualizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customization_visualizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customization_visualizations_id_seq OWNED BY public.customization_visualizations.id;


--
-- Name: data_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discounts (
    id integer NOT NULL,
    amount integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    discountable_id integer,
    discountable_type character varying(255),
    sale_id integer
);


--
-- Name: discounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.discounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.discounts_id_seq OWNED BY public.discounts.id;


--
-- Name: spree_option_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_option_types (
    id integer NOT NULL,
    name character varying(100),
    presentation character varying(100),
    "position" integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_option_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_option_values (
    id integer NOT NULL,
    "position" integer,
    name character varying(255),
    presentation character varying(255),
    option_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    value character varying(255),
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    use_in_customisation boolean DEFAULT false
);


--
-- Name: dress_colours; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dress_colours AS
 SELECT v.id,
    v."position",
    v.name,
    v.presentation,
    v.option_type_id,
    v.created_at,
    v.updated_at,
    v.value,
    v.image_file_name,
    v.image_content_type,
    v.image_file_size,
    v.use_in_customisation
   FROM (public.spree_option_values v
     JOIN public.spree_option_types t ON ((t.id = v.option_type_id)))
  WHERE ((t.name)::text = 'dress-color'::text);


--
-- Name: email_notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email_notifications (
    id integer NOT NULL,
    spree_user_id integer,
    code character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: email_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_notifications_id_seq OWNED BY public.email_notifications.id;


--
-- Name: fabric_card_colours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fabric_card_colours (
    id integer NOT NULL,
    "position" text,
    code text,
    fabric_colour_id integer,
    fabric_card_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fabric_card_colours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fabric_card_colours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fabric_card_colours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fabric_card_colours_id_seq OWNED BY public.fabric_card_colours.id;


--
-- Name: fabric_cards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fabric_cards (
    id integer NOT NULL,
    name text NOT NULL,
    code text,
    name_zh text,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fabric_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fabric_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fabric_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fabric_cards_id_seq OWNED BY public.fabric_cards.id;


--
-- Name: fabric_colours; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fabric_colours (
    id integer NOT NULL,
    name text,
    dress_colour_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fabric_colours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fabric_colours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fabric_colours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fabric_colours_id_seq OWNED BY public.fabric_colours.id;


--
-- Name: fabrication_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fabrication_events (
    id integer NOT NULL,
    fabrication_uuid character varying(255),
    event_type character varying(255),
    data text,
    created_at timestamp without time zone,
    occurred_at timestamp without time zone
);


--
-- Name: fabrication_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fabrication_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fabrication_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fabrication_events_id_seq OWNED BY public.fabrication_events.id;


--
-- Name: fabrications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fabrications (
    id integer NOT NULL,
    line_item_id integer,
    purchase_order_number character varying(255),
    state character varying(255),
    factory_name character varying(255),
    sla_date date,
    uuid character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: fabrications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fabrications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fabrications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fabrications_id_seq OWNED BY public.fabrications.id;


--
-- Name: fabrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fabrics (
    id integer NOT NULL,
    name character varying(255),
    presentation character varying(255),
    price_aud character varying(255),
    price_usd character varying(255),
    material character varying(255),
    image_url character varying(255),
    option_value_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    option_fabric_color_value_id integer,
    production_code character varying(255),
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone
);


--
-- Name: fabrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fabrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fabrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fabrics_id_seq OWNED BY public.fabrics.id;


--
-- Name: fabrics_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fabrics_products (
    id integer NOT NULL,
    fabric_id integer,
    product_id integer,
    recommended boolean,
    description character varying(255),
    active boolean DEFAULT true
);


--
-- Name: fabrics_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fabrics_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fabrics_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fabrics_products_id_seq OWNED BY public.fabrics_products.id;


--
-- Name: facebook_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facebook_accounts (
    id integer NOT NULL,
    facebook_id character varying(255),
    name character varying(255),
    account_status integer,
    amount_spent integer,
    currency character varying(255),
    age double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facebook_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facebook_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facebook_accounts_id_seq OWNED BY public.facebook_accounts.id;


--
-- Name: facebook_ad_creatives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facebook_ad_creatives (
    id integer NOT NULL,
    facebook_id character varying(255),
    facebook_ad_id integer,
    image_url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facebook_ad_creatives_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facebook_ad_creatives_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_ad_creatives_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facebook_ad_creatives_id_seq OWNED BY public.facebook_ad_creatives.id;


--
-- Name: facebook_ad_insights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facebook_ad_insights (
    id integer NOT NULL,
    facebook_ad_id integer,
    clicks integer,
    cost_per_action_type integer,
    cpc double precision,
    cpm double precision,
    cpp double precision,
    ctr double precision,
    date_start timestamp without time zone,
    date_stop timestamp without time zone,
    frequency double precision,
    reach double precision,
    relevance_score json,
    social_impressions json,
    spend double precision,
    total_actions double precision,
    total_unique_actions double precision,
    website_ctr json,
    website_clicks integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    actions json,
    action_values json
);


--
-- Name: facebook_ad_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facebook_ad_insights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_ad_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facebook_ad_insights_id_seq OWNED BY public.facebook_ad_insights.id;


--
-- Name: facebook_ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facebook_ads (
    id integer NOT NULL,
    facebook_id character varying(255),
    facebook_adset_id character varying(255),
    name character varying(255),
    created_time timestamp without time zone,
    updated_time timestamp without time zone,
    bid_amount double precision,
    status character varying(255),
    recommendations json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facebook_ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facebook_ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facebook_ads_id_seq OWNED BY public.facebook_ads.id;


--
-- Name: facebook_adsets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facebook_adsets (
    id integer NOT NULL,
    facebook_campaign_id character varying(255),
    facebook_id character varying(255),
    name character varying(255),
    adlabels json,
    adset_schedule json,
    bid_amount double precision,
    daily_budget double precision,
    created_time timestamp without time zone,
    updated_time timestamp without time zone,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    optimization_goal character varying(255),
    status character varying(255),
    targeting json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facebook_adsets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facebook_adsets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_adsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facebook_adsets_id_seq OWNED BY public.facebook_adsets.id;


--
-- Name: facebook_campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facebook_campaigns (
    id integer NOT NULL,
    facebook_id character varying(255),
    name character varying(255),
    created_time timestamp without time zone,
    start_time timestamp without time zone,
    stop_time timestamp without time zone,
    updated_time timestamp without time zone,
    status character varying(255),
    recommendations json,
    facebook_account_id character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facebook_campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facebook_campaigns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facebook_campaigns_id_seq OWNED BY public.facebook_campaigns.id;


--
-- Name: facebook_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.facebook_data (
    id integer NOT NULL,
    spree_user_id integer,
    value text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: facebook_data_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.facebook_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: facebook_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.facebook_data_id_seq OWNED BY public.facebook_data.id;


--
-- Name: factories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.factories (
    id integer NOT NULL,
    name text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    production_email text
);


--
-- Name: factories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.factories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: factories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.factories_id_seq OWNED BY public.factories.id;


--
-- Name: global_skus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.global_skus (
    id integer NOT NULL,
    sku character varying(255),
    style_number character varying(255),
    product_name character varying(255),
    size character varying(255),
    color_id character varying(255),
    color_name character varying(255),
    customisation_id character varying(255),
    customisation_name character varying(255),
    height_value character varying(255),
    data text,
    product_id integer,
    variant_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fabric_id integer,
    fabric_name character varying(255)
);


--
-- Name: global_skus_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.global_skus_id_seq
    START WITH 10000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: global_skus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.global_skus_id_seq OWNED BY public.global_skus.id;


--
-- Name: incompatibilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.incompatibilities (
    id integer NOT NULL,
    original_id integer,
    incompatible_id integer
);


--
-- Name: incompatibilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.incompatibilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: incompatibilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.incompatibilities_id_seq OWNED BY public.incompatibilities.id;


--
-- Name: inspirations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inspirations (
    id integer NOT NULL,
    spree_product_id integer,
    active boolean DEFAULT true,
    item_type character varying(50),
    content character varying(512),
    "position" integer DEFAULT 0,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    title character varying(255)
);


--
-- Name: inspirations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inspirations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inspirations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inspirations_id_seq OWNED BY public.inspirations.id;


--
-- Name: item_return_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_return_events (
    id integer NOT NULL,
    item_return_uuid character varying(255),
    event_type character varying(255),
    data text,
    created_at timestamp without time zone,
    occurred_at timestamp without time zone
);


--
-- Name: item_return_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_return_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_return_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_return_events_id_seq OWNED BY public.item_return_events.id;


--
-- Name: item_return_labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_return_labels (
    id integer NOT NULL,
    label_url character varying(255),
    carrier character varying(255),
    label_image_url character varying(255),
    label_pdf_url character varying(255),
    item_return_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    barcode character varying(255)
);


--
-- Name: item_return_labels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_return_labels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_return_labels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_return_labels_id_seq OWNED BY public.item_return_labels.id;


--
-- Name: item_returns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_returns (
    id integer NOT NULL,
    order_number character varying(255),
    line_item_id integer,
    qty integer,
    requested_action character varying(255),
    requested_at timestamp without time zone,
    request_id integer,
    reason_category character varying(255),
    reason_sub_category character varying(255),
    request_notes text,
    customer_name character varying(255),
    contact_email character varying(255),
    acceptance_status character varying(255),
    comments text,
    product_name character varying(255),
    product_style_number character varying(255),
    product_colour character varying(255),
    product_size character varying(255),
    product_customisations boolean,
    received_on date,
    received_location character varying(255),
    order_payment_method character varying(255),
    order_payment_date date,
    order_paid_amount integer,
    order_paid_currency character varying(255),
    order_payment_ref character varying(255),
    refund_status character varying(255),
    refund_ref character varying(255),
    refund_method character varying(255),
    refund_amount integer,
    refunded_at timestamp without time zone,
    uuid character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    factory_fault boolean,
    item_price integer,
    item_price_adjusted integer,
    factory_fault_reason character varying(255),
    bergen_asn_number character varying(255),
    bergen_actual_quantity integer,
    bergen_damaged_quantity integer,
    shippo_tracking_number character varying(255),
    shippo_label_url character varying(255),
    item_return_label_id integer
);


--
-- Name: item_returns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.item_returns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: item_returns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.item_returns_id_seq OWNED BY public.item_returns.id;


--
-- Name: layer_cads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.layer_cads (
    id integer NOT NULL,
    product_id integer,
    "position" integer,
    base_image_name character varying(255),
    layer_image_name character varying(255),
    base_image_file_name character varying(255),
    base_image_content_type character varying(255),
    base_image_file_size integer,
    base_image_updated_at timestamp without time zone,
    layer_image_file_name character varying(255),
    layer_image_content_type character varying(255),
    layer_image_file_size integer,
    layer_image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    customizations_enabled_for character varying(255) DEFAULT '--- []
'::character varying,
    width integer,
    height integer
);


--
-- Name: layer_cads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.layer_cads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: layer_cads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.layer_cads_id_seq OWNED BY public.layer_cads.id;


--
-- Name: line_item_making_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_item_making_options (
    id integer NOT NULL,
    product_id integer,
    old_variant_id integer,
    line_item_id integer,
    making_option_id integer,
    flat_price numeric(10,2),
    currency character varying(10),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    percent_price numeric(8,2)
);


--
-- Name: line_item_making_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.line_item_making_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_item_making_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.line_item_making_options_id_seq OWNED BY public.line_item_making_options.id;


--
-- Name: line_item_personalizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_item_personalizations (
    id integer NOT NULL,
    line_item_id integer,
    product_id integer,
    size character varying(255),
    customization_value_ids character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    color character varying(255),
    color_id integer,
    price numeric(8,2) DEFAULT 0.0,
    size_id integer,
    height character varying(255) DEFAULT 'standard'::character varying,
    height_value character varying(255),
    height_unit character varying(255),
    sku character varying(128)
);


--
-- Name: line_item_personalizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.line_item_personalizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_item_personalizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.line_item_personalizations_id_seq OWNED BY public.line_item_personalizations.id;


--
-- Name: line_item_size_normalisations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_item_size_normalisations (
    id integer NOT NULL,
    line_item_id integer,
    line_item_personalization_id integer,
    order_number character varying(255),
    order_created_at timestamp without time zone,
    currency character varying(255),
    site_version character varying(255),
    old_size_value character varying(255),
    old_size_id integer,
    old_variant_id integer,
    new_size_value character varying(255),
    new_size_id integer,
    new_variant_id integer,
    messages character varying(255),
    state character varying(255),
    processed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: line_item_size_normalisations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.line_item_size_normalisations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_item_size_normalisations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.line_item_size_normalisations_id_seq OWNED BY public.line_item_size_normalisations.id;


--
-- Name: line_item_updates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_item_updates (
    id integer NOT NULL,
    row_number integer,
    order_date text,
    order_number text,
    style_name text,
    size text,
    quantity text,
    colour text,
    tracking_number text,
    dispatch_date text,
    delivery_method text,
    bulk_order_update_id integer,
    order_id integer,
    line_item_id integer,
    shipment_id integer,
    state text,
    process_reason text,
    match_errors text,
    shipment_errors text,
    processed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    make_state character varying(255),
    raw_line_item character varying(255),
    setup_ship_errors text
);


--
-- Name: line_item_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.line_item_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_item_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.line_item_updates_id_seq OWNED BY public.line_item_updates.id;


--
-- Name: making_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.making_options (
    id integer NOT NULL,
    code character varying(255),
    name character varying(255),
    description character varying(255),
    delivery_period character varying(255),
    cny_delivery_period character varying(255),
    making_time_business_days integer,
    cny_making_time_business_days integer,
    flat_price_usd numeric(8,2),
    flat_price_aud numeric(8,2),
    percent_price_usd numeric(8,2),
    percent_price_aud numeric(8,2),
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delivery_time_days integer,
    cny_delivery_time_days integer
);


--
-- Name: making_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.making_options_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: making_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.making_options_id_seq OWNED BY public.making_options.id;


--
-- Name: manually_managed_returns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.manually_managed_returns (
    id integer NOT NULL,
    item_return_id integer,
    item_return_event_id integer,
    line_item_id integer,
    import_status character varying(255),
    row_number character varying(255),
    rj_ident character varying(255),
    column_b character varying(255),
    receive_state character varying(255),
    spree_order_number character varying(255),
    return_cancellation_credit character varying(255),
    name character varying(255),
    order_date character varying(255),
    order_month character varying(255),
    return_requested_on character varying(255),
    comments text,
    product character varying(255),
    size character varying(255),
    colour character varying(255),
    return_category character varying(255),
    return_sub_category character varying(255),
    return_office character varying(255),
    received character varying(255),
    in_inventory character varying(255),
    notes text,
    restocking character varying(255),
    returned_to_factory character varying(255),
    refund_status character varying(255),
    payment_method character varying(255),
    refund_method character varying(255),
    currency character varying(255),
    amount_paid character varying(255),
    spree_amount_paid character varying(255),
    refund_amount character varying(255),
    date_refunded character varying(255),
    email character varying(255),
    account_name character varying(255),
    account_number character varying(255),
    account_bsb character varying(255),
    account_swift character varying(255),
    customers_notes text,
    quantity character varying(255),
    deleted_row character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: manually_managed_returns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.manually_managed_returns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: manually_managed_returns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.manually_managed_returns_id_seq OWNED BY public.manually_managed_returns.id;


--
-- Name: marketing_body_calculator_measures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.marketing_body_calculator_measures (
    id integer NOT NULL,
    email character varying(255),
    shape character varying(255),
    size character varying(255),
    bust_circumference double precision DEFAULT 0.0,
    under_bust_circumference double precision DEFAULT 0.0,
    waist_circumference double precision DEFAULT 0.0,
    hip_circumference double precision DEFAULT 0.0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    unit character varying(255)
);


--
-- Name: marketing_body_calculator_measures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.marketing_body_calculator_measures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: marketing_body_calculator_measures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.marketing_body_calculator_measures_id_seq OWNED BY public.marketing_body_calculator_measures.id;


--
-- Name: marketing_order_traffic_parameters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.marketing_order_traffic_parameters (
    id integer NOT NULL,
    order_id integer,
    utm_campaign character varying(255),
    utm_source character varying(255),
    utm_medium character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: marketing_order_traffic_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.marketing_order_traffic_parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: marketing_order_traffic_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.marketing_order_traffic_parameters_id_seq OWNED BY public.marketing_order_traffic_parameters.id;


--
-- Name: marketing_user_visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.marketing_user_visits (
    id integer NOT NULL,
    spree_user_id integer,
    user_token character varying(64),
    visits integer DEFAULT 0,
    utm_campaign character varying(255),
    utm_source character varying(255),
    utm_medium character varying(255),
    utm_term character varying(255),
    utm_content character varying(255),
    referrer character varying(255),
    category character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: marketing_user_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.marketing_user_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: marketing_user_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.marketing_user_visits_id_seq OWNED BY public.marketing_user_visits.id;


--
-- Name: moodboard_collaborators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.moodboard_collaborators (
    id integer NOT NULL,
    moodboard_id integer,
    user_id integer,
    email character varying(255),
    name character varying(255),
    accepted_at timestamp without time zone,
    deleted_at timestamp without time zone,
    deleted_by character varying(255),
    mute_notifications boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: moodboard_collaborators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.moodboard_collaborators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moodboard_collaborators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.moodboard_collaborators_id_seq OWNED BY public.moodboard_collaborators.id;


--
-- Name: moodboard_item_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.moodboard_item_comments (
    id integer NOT NULL,
    moodboard_item_id integer,
    user_id integer,
    comment text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: moodboard_item_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.moodboard_item_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moodboard_item_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.moodboard_item_comments_id_seq OWNED BY public.moodboard_item_comments.id;


--
-- Name: moodboard_item_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.moodboard_item_events (
    id integer NOT NULL,
    moodboard_item_uuid character varying(255),
    event_type character varying(255),
    data text,
    created_at timestamp without time zone,
    occurred_at timestamp without time zone
);


--
-- Name: moodboard_item_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.moodboard_item_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moodboard_item_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.moodboard_item_events_id_seq OWNED BY public.moodboard_item_events.id;


--
-- Name: moodboard_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.moodboard_items (
    id integer NOT NULL,
    uuid character varying(255),
    moodboard_id integer,
    product_id integer NOT NULL,
    product_color_value_id integer,
    color_id integer NOT NULL,
    variant_id integer,
    user_id integer NOT NULL,
    likes integer DEFAULT 0,
    comments text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_likes character varying(255) DEFAULT ''::character varying
);


--
-- Name: moodboard_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.moodboard_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moodboard_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.moodboard_items_id_seq OWNED BY public.moodboard_items.id;


--
-- Name: moodboards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.moodboards (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    purpose character varying(255) DEFAULT 'default'::character varying NOT NULL,
    event_date date,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    event_progress character varying(255),
    owner_relationship character varying(255),
    guest_count character varying(255),
    bride_first_name character varying(255),
    bride_last_name character varying(255)
);


--
-- Name: moodboards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.moodboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: moodboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.moodboards_id_seq OWNED BY public.moodboards.id;


--
-- Name: newgistics_schedulers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.newgistics_schedulers (
    id integer NOT NULL,
    last_successful_run character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255)
);


--
-- Name: newgistics_schedulers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.newgistics_schedulers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newgistics_schedulers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.newgistics_schedulers_id_seq OWNED BY public.newgistics_schedulers.id;


--
-- Name: next_logistics_return_request_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.next_logistics_return_request_processes (
    id integer NOT NULL,
    order_return_request_id integer,
    aasm_state character varying(255),
    failed boolean DEFAULT false,
    error_id character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: next_logistics_return_request_processes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.next_logistics_return_request_processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: next_logistics_return_request_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.next_logistics_return_request_processes_id_seq OWNED BY public.next_logistics_return_request_processes.id;


--
-- Name: old_variant_taxons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.old_variant_taxons (
    id integer NOT NULL,
    taxon_id integer,
    product_id integer,
    fabric_or_color character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: old_variant_taxons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.old_variant_taxons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_variant_taxons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.old_variant_taxons_id_seq OWNED BY public.old_variant_taxons.id;


--
-- Name: option_values_option_values_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.option_values_option_values_groups (
    option_value_id integer,
    option_values_group_id integer
);


--
-- Name: order_return_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_return_requests (
    id integer NOT NULL,
    order_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: order_return_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.order_return_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_return_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.order_return_requests_id_seq OWNED BY public.order_return_requests.id;


--
-- Name: order_shipments_factories_concrete; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_shipments_factories_concrete (
    id integer NOT NULL,
    number character varying(15),
    state character varying(255),
    completed_at date,
    projected_delivery_date date,
    shipped_at date,
    array_to_string text,
    days_to_ship double precision,
    num_items bigint,
    shipped_in_7 boolean,
    shipped_before_delivery boolean,
    updated_at timestamp without time zone
);


--
-- Name: payment_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payment_requests (
    id integer NOT NULL,
    order_id integer,
    recipient_full_name character varying(255),
    recipient_email character varying(255),
    message text,
    token character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: payment_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payment_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payment_requests_id_seq OWNED BY public.payment_requests.id;


--
-- Name: product_accessories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_accessories (
    id integer NOT NULL,
    style_id integer,
    spree_product_id integer,
    "position" integer,
    active boolean DEFAULT true,
    title character varying(512),
    name character varying(512),
    source character varying(512),
    price numeric(8,2),
    currency character varying(255),
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_accessories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_accessories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_accessories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_accessories_id_seq OWNED BY public.product_accessories.id;


--
-- Name: product_color_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_color_values (
    id integer NOT NULL,
    product_id integer,
    option_value_id integer,
    active boolean DEFAULT true,
    custom boolean DEFAULT false
);


--
-- Name: product_color_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_color_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_color_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_color_values_id_seq OWNED BY public.product_color_values.id;


--
-- Name: product_height_range_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_height_range_groups (
    id integer NOT NULL,
    unit character varying(255),
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_height_range_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_height_range_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_height_range_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_height_range_groups_id_seq OWNED BY public.product_height_range_groups.id;


--
-- Name: product_height_ranges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_height_ranges (
    id integer NOT NULL,
    min integer,
    max integer,
    unit character varying(255),
    map_to character varying(255),
    product_height_range_group_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_height_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_height_ranges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_height_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_height_ranges_id_seq OWNED BY public.product_height_ranges.id;


--
-- Name: product_making_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_making_options (
    id integer NOT NULL,
    product_id integer,
    old_variant_id integer,
    active boolean DEFAULT false,
    old_option_type character varying(255),
    old_price numeric(10,2),
    old_currency character varying(10),
    making_option_id integer,
    "default" boolean
);


--
-- Name: product_making_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_making_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_making_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_making_options_id_seq OWNED BY public.product_making_options.id;


--
-- Name: product_personalizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_personalizations (
    id integer NOT NULL,
    variant_id integer,
    line_item_id integer,
    user_id integer,
    user_first_name character varying(255),
    user_last_name character varying(255),
    user_email character varying(255),
    change_color boolean,
    change_hem_length boolean,
    change_neck_line boolean,
    change_fabric_type boolean,
    merge_styles boolean,
    add_beads_or_sequins boolean,
    comments text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_personalizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_personalizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_personalizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_personalizations_id_seq OWNED BY public.product_personalizations.id;


--
-- Name: product_reservations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_reservations (
    id integer NOT NULL,
    user_id integer,
    product_id integer,
    school_name character varying(255),
    formal_name character varying(255),
    school_year character varying(255),
    color character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_reservations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_reservations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_reservations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_reservations_id_seq OWNED BY public.product_reservations.id;


--
-- Name: product_style_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_style_profiles (
    id integer NOT NULL,
    product_id integer,
    glam integer,
    girly integer,
    classic integer,
    edgy integer,
    bohemian integer,
    apple integer,
    pear integer,
    strawberry integer,
    hour_glass integer,
    "column" integer,
    bra_aaa integer,
    bra_aa integer,
    bra_a integer,
    bra_b integer,
    bra_c integer,
    bra_d integer,
    bra_e integer,
    bra_fpp integer,
    sexiness integer,
    fashionability integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    athletic integer,
    petite integer
);


--
-- Name: product_style_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_style_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_style_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_style_profiles_id_seq OWNED BY public.product_style_profiles.id;


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id integer NOT NULL,
    quiz_id integer,
    text character varying(255),
    "position" character varying(255),
    partial character varying(255),
    multiple boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    populate character varying(255),
    step integer
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.questions_id_seq OWNED BY public.questions.id;


--
-- Name: quizzes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quizzes (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: quizzes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quizzes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quizzes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quizzes_id_seq OWNED BY public.quizzes.id;


--
-- Name: redirected_search_terms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.redirected_search_terms (
    id integer NOT NULL,
    term character varying(255),
    redirect_to character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: redirected_search_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.redirected_search_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: redirected_search_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.redirected_search_terms_id_seq OWNED BY public.redirected_search_terms.id;


--
-- Name: refund_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.refund_requests (
    id integer NOT NULL,
    order_id integer,
    payment_id integer,
    order_number character varying(255),
    payment_ref character varying(255) NOT NULL,
    currency character varying(255),
    payment_amount integer,
    acceptance_status character varying(255),
    requested_refund_amount integer,
    payment_created_at timestamp without time zone,
    customer_name character varying(255),
    customer_email character varying(255),
    refund_ref character varying(255),
    refund_currency character varying(255),
    refund_success character varying(255),
    refund_amount integer,
    refund_created_at timestamp without time zone,
    refund_status_message character varying(255),
    public_key character varying(255),
    secret_key character varying(255),
    api_url character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: refund_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.refund_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refund_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.refund_requests_id_seq OWNED BY public.refund_requests.id;


--
-- Name: render3d_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.render3d_images (
    id integer NOT NULL,
    attachment_file_name character varying(255),
    attachment_content_type character varying(255),
    attachment_file_size integer,
    attachment_updated_at timestamp without time zone,
    product_id integer,
    customisation_value_id integer,
    color_value_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: render3d_images_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.render3d_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: render3d_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.render3d_images_id_seq OWNED BY public.render3d_images.id;


--
-- Name: return_inventory_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.return_inventory_items (
    id integer NOT NULL,
    upc integer NOT NULL,
    style_number character varying(255),
    available integer NOT NULL,
    vendor character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    active boolean DEFAULT true
);


--
-- Name: return_inventory_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.return_inventory_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: return_inventory_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.return_inventory_items_id_seq OWNED BY public.return_inventory_items.id;


--
-- Name: return_request_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.return_request_items (
    id integer NOT NULL,
    order_return_request_id integer,
    line_item_id integer,
    quantity integer,
    action text,
    reason_category text,
    reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: return_request_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.return_request_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: return_request_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.return_request_items_id_seq OWNED BY public.return_request_items.id;


--
-- Name: revolution_pages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revolution_pages (
    id integer NOT NULL,
    template_id integer,
    path text,
    template_path text,
    canonical text,
    redirect text,
    variables text,
    publish_from timestamp without time zone,
    publish_to timestamp without time zone,
    parent_id integer,
    lft integer NOT NULL,
    rgt integer NOT NULL,
    depth integer DEFAULT 0 NOT NULL,
    children_count integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    noindex boolean DEFAULT false,
    nofollow boolean DEFAULT false,
    product_order character varying(255)
);


--
-- Name: revolution_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revolution_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revolution_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.revolution_pages_id_seq OWNED BY public.revolution_pages.id;


--
-- Name: revolution_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revolution_translations (
    id integer NOT NULL,
    page_id integer,
    locale text,
    title text,
    meta_description text,
    heading text,
    sub_heading text,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: revolution_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revolution_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: revolution_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.revolution_translations_id_seq OWNED BY public.revolution_translations.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: similarities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.similarities (
    id integer NOT NULL,
    original_id integer,
    similar_id integer,
    coefficient double precision
);


--
-- Name: similarities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.similarities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: similarities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.similarities_id_seq OWNED BY public.similarities.id;


--
-- Name: simple_key_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.simple_key_values (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: simple_key_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.simple_key_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: simple_key_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.simple_key_values_id_seq OWNED BY public.simple_key_values.id;


--
-- Name: site_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.site_versions (
    id integer NOT NULL,
    zone_id integer,
    name character varying(255),
    permalink character varying(255),
    "default" boolean DEFAULT false,
    active boolean DEFAULT false,
    currency character varying(255),
    locale character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    exchange_rate_timestamp date,
    exchange_rate numeric DEFAULT 1,
    domain character varying(255) DEFAULT ''::character varying NOT NULL
);


--
-- Name: site_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.site_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: site_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.site_versions_id_seq OWNED BY public.site_versions.id;


--
-- Name: spree_activators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_activators (
    id integer NOT NULL,
    description character varying(255),
    expires_at timestamp without time zone,
    starts_at timestamp without time zone,
    name character varying(255),
    event_name character varying(255),
    type character varying(255),
    usage_limit integer,
    match_policy character varying(255) DEFAULT 'all'::character varying,
    code character varying(255),
    advertise boolean DEFAULT false,
    path character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    eligible_to_custom_order boolean DEFAULT false,
    eligible_to_sale_order boolean DEFAULT false,
    require_shipping_charge boolean DEFAULT false
);


--
-- Name: spree_activators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_activators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_activators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_activators_id_seq OWNED BY public.spree_activators.id;


--
-- Name: spree_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_addresses (
    id integer NOT NULL,
    firstname character varying(255),
    lastname character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    zipcode character varying(255),
    phone character varying(255),
    state_name character varying(255),
    alternative_phone character varying(255),
    company character varying(255),
    state_id integer,
    country_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying(255)
);


--
-- Name: spree_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_addresses_id_seq OWNED BY public.spree_addresses.id;


--
-- Name: spree_adjustments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_adjustments (
    id integer NOT NULL,
    source_id integer,
    source_type character varying(255),
    adjustable_id integer,
    adjustable_type character varying(255),
    originator_id integer,
    originator_type character varying(255),
    amount numeric(10,2),
    label character varying(255),
    mandatory boolean,
    locked boolean,
    eligible boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_adjustments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_adjustments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_adjustments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_adjustments_id_seq OWNED BY public.spree_adjustments.id;


--
-- Name: spree_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_assets (
    id integer NOT NULL,
    viewable_id integer,
    viewable_type character varying(255),
    attachment_width integer,
    attachment_height integer,
    attachment_file_size integer,
    "position" integer,
    attachment_content_type character varying(255),
    attachment_file_name character varying(255),
    type character varying(75),
    attachment_updated_at timestamp without time zone,
    alt text
);


--
-- Name: spree_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_assets_id_seq OWNED BY public.spree_assets.id;


--
-- Name: spree_authentication_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_authentication_methods (
    id integer NOT NULL,
    environment character varying(255),
    provider character varying(255),
    api_key character varying(255),
    api_secret character varying(255),
    active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_authentication_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_authentication_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_authentication_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_authentication_methods_id_seq OWNED BY public.spree_authentication_methods.id;


--
-- Name: spree_banner_boxes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_banner_boxes (
    id integer NOT NULL,
    presentation character varying(255),
    url character varying(255),
    category character varying(255),
    "position" integer,
    enabled boolean DEFAULT false,
    attachment_content_type character varying(255),
    attachment_file_name character varying(255),
    attachment_updated_at timestamp without time zone,
    attachment_width integer,
    attachment_height integer,
    attachment_size integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_small boolean,
    css_class text,
    title text
);


--
-- Name: spree_banner_boxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_banner_boxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_banner_boxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_banner_boxes_id_seq OWNED BY public.spree_banner_boxes.id;


--
-- Name: spree_calculators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_calculators (
    id integer NOT NULL,
    type character varying(255),
    calculable_id integer,
    calculable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_calculators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_calculators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_calculators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_calculators_id_seq OWNED BY public.spree_calculators.id;


--
-- Name: spree_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_configurations (
    id integer NOT NULL,
    name character varying(255),
    type character varying(50),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_configurations_id_seq OWNED BY public.spree_configurations.id;


--
-- Name: spree_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_countries (
    id integer NOT NULL,
    iso_name character varying(255),
    iso character varying(255),
    iso3 character varying(255),
    name character varying(255),
    numcode integer,
    states_required boolean DEFAULT true
);


--
-- Name: spree_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_countries_id_seq OWNED BY public.spree_countries.id;


--
-- Name: spree_credit_cards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_credit_cards (
    id integer NOT NULL,
    month character varying(255),
    year character varying(255),
    cc_type character varying(255),
    last_digits character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    start_month character varying(255),
    start_year character varying(255),
    issue_number character varying(255),
    address_id integer,
    gateway_customer_profile_id character varying(255),
    gateway_payment_profile_id character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_credit_cards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_credit_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_credit_cards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_credit_cards_id_seq OWNED BY public.spree_credit_cards.id;


--
-- Name: spree_gateways; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_gateways (
    id integer NOT NULL,
    type character varying(255),
    name character varying(255),
    description text,
    active boolean DEFAULT true,
    environment character varying(255) DEFAULT 'development'::character varying,
    server character varying(255) DEFAULT 'test'::character varying,
    test_mode boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_gateways_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_gateways_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_gateways_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_gateways_id_seq OWNED BY public.spree_gateways.id;


--
-- Name: spree_inventory_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_inventory_units (
    id integer NOT NULL,
    lock_version integer DEFAULT 0,
    state character varying(255),
    variant_id integer,
    order_id integer,
    shipment_id integer,
    return_authorization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_inventory_units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_inventory_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_inventory_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_inventory_units_id_seq OWNED BY public.spree_inventory_units.id;


--
-- Name: spree_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_line_items (
    id integer NOT NULL,
    variant_id integer,
    order_id integer,
    quantity integer NOT NULL,
    price numeric(8,2) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    currency character varying(255),
    old_price numeric(8,2),
    delivery_date character varying(255),
    customizations jsonb,
    stock boolean,
    color character varying(255),
    size character varying(255),
    length character varying(255),
    upc character varying(255),
    fabric_id integer,
    return_inventory_item_id integer,
    refulfill_status character varying(255),
    curation_name text
);


--
-- Name: spree_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_line_items_id_seq OWNED BY public.spree_line_items.id;


--
-- Name: spree_log_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_log_entries (
    id integer NOT NULL,
    source_id integer,
    source_type character varying(255),
    details text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_log_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_log_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_log_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_log_entries_id_seq OWNED BY public.spree_log_entries.id;


--
-- Name: spree_mail_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_mail_methods (
    id integer NOT NULL,
    environment character varying(255),
    active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_mail_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_mail_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_mail_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_mail_methods_id_seq OWNED BY public.spree_mail_methods.id;


--
-- Name: spree_masterpass_checkouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_masterpass_checkouts (
    id integer NOT NULL,
    access_token character varying(255),
    transaction_id character varying(255),
    precheckout_transaction_id character varying(255),
    cardholder_name character varying(255),
    account_number character varying(255),
    billing_address character varying(255),
    exp_date date,
    brand_id character varying(255),
    contact_name character varying(255),
    gender character varying(255),
    birthday date,
    national_id character varying(255),
    phone character varying(255),
    email character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    order_id integer
);


--
-- Name: spree_masterpass_checkouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_masterpass_checkouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_masterpass_checkouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_masterpass_checkouts_id_seq OWNED BY public.spree_masterpass_checkouts.id;


--
-- Name: spree_option_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_option_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_option_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_option_types_id_seq OWNED BY public.spree_option_types.id;


--
-- Name: spree_option_types_prototypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_option_types_prototypes (
    prototype_id integer,
    option_type_id integer
);


--
-- Name: spree_option_values_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_option_values_groups (
    id integer NOT NULL,
    option_type_id integer,
    name character varying(255),
    presentation character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    available_as_taxon boolean DEFAULT false
);


--
-- Name: spree_option_values_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_option_values_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_option_values_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_option_values_groups_id_seq OWNED BY public.spree_option_values_groups.id;


--
-- Name: spree_option_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_option_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_option_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_option_values_id_seq OWNED BY public.spree_option_values.id;


--
-- Name: spree_option_values_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_option_values_variants (
    variant_id integer,
    option_value_id integer
);


--
-- Name: spree_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_orders (
    id integer NOT NULL,
    number character varying(15),
    item_total numeric(10,2) DEFAULT 0.0 NOT NULL,
    total numeric(10,2) DEFAULT 0.0 NOT NULL,
    state character varying(255),
    adjustment_total numeric(10,2) DEFAULT 0.0 NOT NULL,
    user_id integer,
    completed_at timestamp without time zone,
    bill_address_id integer,
    ship_address_id integer,
    payment_total numeric(10,2) DEFAULT 0.0,
    shipping_method_id integer,
    shipment_state character varying(255),
    payment_state character varying(255),
    email character varying(255),
    special_instructions text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    currency character varying(255),
    last_ip_address character varying(255),
    user_first_name character varying(255),
    user_last_name character varying(255),
    required_to date,
    customer_notes text,
    projected_delivery_date timestamp without time zone,
    site_version text,
    orderbot_synced boolean,
    return_type character varying(255),
    vwo_type character varying(255),
    autorefundable boolean
);


--
-- Name: spree_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_orders_id_seq OWNED BY public.spree_orders.id;


--
-- Name: spree_payment_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_payment_methods (
    id integer NOT NULL,
    type character varying(255),
    name character varying(255),
    description text,
    active boolean DEFAULT true,
    environment character varying(255) DEFAULT 'development'::character varying,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    display_on character varying(255)
);


--
-- Name: spree_payment_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_payment_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_payment_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_payment_methods_id_seq OWNED BY public.spree_payment_methods.id;


--
-- Name: spree_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_payments (
    id integer NOT NULL,
    amount numeric(10,2) DEFAULT 0.0 NOT NULL,
    order_id integer,
    source_id integer,
    source_type character varying(255),
    payment_method_id integer,
    state character varying(255),
    response_code character varying(255),
    avs_response character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    identifier character varying(255),
    cvv_response_code character varying(255),
    cvv_response_message character varying(255)
);


--
-- Name: spree_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_payments_id_seq OWNED BY public.spree_payments.id;


--
-- Name: spree_paypal_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_paypal_accounts (
    id integer NOT NULL,
    email character varying(255),
    payer_id character varying(255),
    payer_country character varying(255),
    payer_status character varying(255)
);


--
-- Name: spree_paypal_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_paypal_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_paypal_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_paypal_accounts_id_seq OWNED BY public.spree_paypal_accounts.id;


--
-- Name: spree_paypal_express_checkouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_paypal_express_checkouts (
    id integer NOT NULL,
    token character varying(255),
    payer_id character varying(255),
    transaction_id character varying(255),
    state character varying(255) DEFAULT 'complete'::character varying,
    refund_transaction_id character varying(255),
    refunded_at timestamp without time zone,
    refund_type character varying(255),
    created_at timestamp without time zone
);


--
-- Name: spree_paypal_express_checkouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_paypal_express_checkouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_paypal_express_checkouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_paypal_express_checkouts_id_seq OWNED BY public.spree_paypal_express_checkouts.id;


--
-- Name: spree_preferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_preferences (
    id integer NOT NULL,
    value text,
    key character varying(255),
    value_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_preferences_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_preferences_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_preferences_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_preferences_id_seq OWNED BY public.spree_preferences.id;


--
-- Name: spree_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_prices (
    id integer NOT NULL,
    variant_id integer NOT NULL,
    amount numeric(8,2),
    currency character varying(255)
);


--
-- Name: spree_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_prices_id_seq OWNED BY public.spree_prices.id;


--
-- Name: spree_product_option_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_product_option_types (
    id integer NOT NULL,
    "position" integer,
    product_id integer,
    option_type_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_product_option_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_product_option_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_product_option_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_product_option_types_id_seq OWNED BY public.spree_product_option_types.id;


--
-- Name: spree_product_properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_product_properties (
    id integer NOT NULL,
    value character varying(512),
    product_id integer,
    property_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0
);


--
-- Name: spree_product_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_product_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_product_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_product_properties_id_seq OWNED BY public.spree_product_properties.id;


--
-- Name: spree_product_related_outerwear; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_product_related_outerwear (
    id integer NOT NULL,
    outerwear_id integer,
    product_id integer
);


--
-- Name: spree_product_related_outerwear_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_product_related_outerwear_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_product_related_outerwear_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_product_related_outerwear_id_seq OWNED BY public.spree_product_related_outerwear.id;


--
-- Name: spree_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_products (
    id integer NOT NULL,
    name character varying(255) DEFAULT ''::character varying NOT NULL,
    description text,
    available_on timestamp without time zone,
    deleted_at timestamp without time zone,
    permalink character varying(255),
    meta_description text,
    meta_keywords character varying(255),
    tax_category_id integer,
    shipping_category_id integer,
    count_on_hand integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    on_demand boolean DEFAULT false,
    featured boolean DEFAULT false,
    "position" integer DEFAULT 0,
    hidden boolean DEFAULT false,
    factory_id integer,
    size_chart character varying(255) DEFAULT '2014'::character varying NOT NULL,
    fabric_card_id integer,
    category_id integer,
    customizations jsonb,
    lengths jsonb
);


--
-- Name: spree_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_products_id_seq OWNED BY public.spree_products.id;


--
-- Name: spree_products_promotion_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_products_promotion_rules (
    product_id integer,
    promotion_rule_id integer
);


--
-- Name: spree_products_taxons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_products_taxons (
    product_id integer,
    taxon_id integer,
    id integer NOT NULL
);


--
-- Name: spree_products_taxons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_products_taxons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_products_taxons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_products_taxons_id_seq OWNED BY public.spree_products_taxons.id;


--
-- Name: spree_promotion_action_line_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_promotion_action_line_items (
    id integer NOT NULL,
    promotion_action_id integer,
    variant_id integer,
    quantity integer DEFAULT 1
);


--
-- Name: spree_promotion_action_line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_promotion_action_line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_promotion_action_line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_promotion_action_line_items_id_seq OWNED BY public.spree_promotion_action_line_items.id;


--
-- Name: spree_promotion_actions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_promotion_actions (
    id integer NOT NULL,
    activator_id integer,
    "position" integer,
    type character varying(255)
);


--
-- Name: spree_promotion_actions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_promotion_actions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_promotion_actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_promotion_actions_id_seq OWNED BY public.spree_promotion_actions.id;


--
-- Name: spree_promotion_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_promotion_rules (
    id integer NOT NULL,
    activator_id integer,
    user_id integer,
    product_group_id integer,
    type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_promotion_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_promotion_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_promotion_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_promotion_rules_id_seq OWNED BY public.spree_promotion_rules.id;


--
-- Name: spree_promotion_rules_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_promotion_rules_users (
    user_id integer,
    promotion_rule_id integer
);


--
-- Name: spree_properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_properties (
    id integer NOT NULL,
    name character varying(255),
    presentation character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_properties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_properties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_properties_id_seq OWNED BY public.spree_properties.id;


--
-- Name: spree_properties_prototypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_properties_prototypes (
    prototype_id integer,
    property_id integer
);


--
-- Name: spree_prototypes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_prototypes (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_prototypes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_prototypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_prototypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_prototypes_id_seq OWNED BY public.spree_prototypes.id;


--
-- Name: spree_return_authorizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_return_authorizations (
    id integer NOT NULL,
    number character varying(255),
    state character varying(255),
    amount numeric(10,2) DEFAULT 0.0 NOT NULL,
    order_id integer,
    reason text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_return_authorizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_return_authorizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_return_authorizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_return_authorizations_id_seq OWNED BY public.spree_return_authorizations.id;


--
-- Name: spree_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_roles (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: spree_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_roles_id_seq OWNED BY public.spree_roles.id;


--
-- Name: spree_roles_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_roles_users (
    role_id integer,
    user_id integer
);


--
-- Name: spree_sales; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_sales (
    id integer NOT NULL,
    is_active boolean,
    discount_size numeric,
    discount_type integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    sitewide boolean DEFAULT false,
    customisation_allowed boolean DEFAULT false,
    sitewide_message character varying(255),
    currency character varying(255) DEFAULT ''::character varying
);


--
-- Name: spree_sales_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_sales_id_seq OWNED BY public.spree_sales.id;


--
-- Name: spree_shipments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_shipments (
    id integer NOT NULL,
    tracking character varying(255),
    number character varying(255),
    cost numeric(8,2),
    shipped_at timestamp without time zone,
    order_id integer,
    shipping_method_id integer,
    address_id integer,
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_shipments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_shipments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_shipments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_shipments_id_seq OWNED BY public.spree_shipments.id;


--
-- Name: spree_shipping_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_shipping_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_shipping_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_shipping_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_shipping_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_shipping_categories_id_seq OWNED BY public.spree_shipping_categories.id;


--
-- Name: spree_shipping_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_shipping_methods (
    id integer NOT NULL,
    name character varying(255),
    zone_id integer,
    display_on character varying(255),
    shipping_category_id integer,
    match_none boolean,
    match_all boolean,
    match_one boolean,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0
);


--
-- Name: spree_shipping_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_shipping_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_shipping_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_shipping_methods_id_seq OWNED BY public.spree_shipping_methods.id;


--
-- Name: spree_skrill_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_skrill_transactions (
    id integer NOT NULL,
    email character varying(255),
    amount double precision,
    currency character varying(255),
    transaction_id integer,
    customer_id integer,
    payment_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_skrill_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_skrill_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_skrill_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_skrill_transactions_id_seq OWNED BY public.spree_skrill_transactions.id;


--
-- Name: spree_state_changes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_state_changes (
    id integer NOT NULL,
    name character varying(255),
    previous_state character varying(255),
    stateful_id integer,
    user_id integer,
    stateful_type character varying(255),
    next_state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_state_changes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_state_changes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_state_changes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_state_changes_id_seq OWNED BY public.spree_state_changes.id;


--
-- Name: spree_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_states (
    id integer NOT NULL,
    name character varying(255),
    abbr character varying(255),
    country_id integer
);


--
-- Name: spree_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_states_id_seq OWNED BY public.spree_states.id;


--
-- Name: spree_tax_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_tax_categories (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    is_default boolean DEFAULT false,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_tax_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_tax_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_tax_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_tax_categories_id_seq OWNED BY public.spree_tax_categories.id;


--
-- Name: spree_tax_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_tax_rates (
    id integer NOT NULL,
    amount numeric(8,5),
    zone_id integer,
    tax_category_id integer,
    included_in_price boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying(255),
    show_rate_in_label boolean DEFAULT true
);


--
-- Name: spree_tax_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_tax_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_tax_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_tax_rates_id_seq OWNED BY public.spree_tax_rates.id;


--
-- Name: spree_taxon_banners; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_taxon_banners (
    id integer NOT NULL,
    spree_taxon_id integer,
    title character varying(255),
    description text,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone,
    footer_text text,
    seo_description text
);


--
-- Name: spree_taxon_banners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_taxon_banners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_taxon_banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_taxon_banners_id_seq OWNED BY public.spree_taxon_banners.id;


--
-- Name: spree_taxonomies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_taxonomies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer DEFAULT 0
);


--
-- Name: spree_taxonomies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_taxonomies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_taxonomies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_taxonomies_id_seq OWNED BY public.spree_taxonomies.id;


--
-- Name: spree_taxons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_taxons (
    id integer NOT NULL,
    parent_id integer,
    "position" integer DEFAULT 0,
    name character varying(255) NOT NULL,
    permalink character varying(255),
    taxonomy_id integer,
    lft integer,
    rgt integer,
    icon_file_name character varying(255),
    icon_content_type character varying(255),
    icon_file_size integer,
    icon_updated_at timestamp without time zone,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    meta_title character varying(255),
    meta_description character varying(255),
    meta_keywords character varying(255),
    title character varying(255),
    published_at timestamp without time zone,
    old_delivery_period character varying(255) DEFAULT '7 - 10 business days'::character varying
);


--
-- Name: spree_taxons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_taxons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_taxons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_taxons_id_seq OWNED BY public.spree_taxons.id;


--
-- Name: spree_tokenized_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_tokenized_permissions (
    id integer NOT NULL,
    permissable_id integer,
    permissable_type character varying(255),
    token character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_tokenized_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_tokenized_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_tokenized_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_tokenized_permissions_id_seq OWNED BY public.spree_tokenized_permissions.id;


--
-- Name: spree_trackers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_trackers (
    id integer NOT NULL,
    environment character varying(255),
    analytics_id character varying(255),
    active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_trackers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_trackers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_trackers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_trackers_id_seq OWNED BY public.spree_trackers.id;


--
-- Name: spree_user_authentications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_user_authentications (
    id integer NOT NULL,
    user_id integer,
    provider character varying(255),
    uid character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_user_authentications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_user_authentications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_user_authentications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_user_authentications_id_seq OWNED BY public.spree_user_authentications.id;


--
-- Name: spree_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_users (
    id integer NOT NULL,
    encrypted_password character varying(128),
    password_salt character varying(128),
    email character varying(255),
    remember_token character varying(255),
    persistence_token character varying(255),
    reset_password_token character varying(255),
    perishable_token character varying(255),
    sign_in_count integer DEFAULT 0 NOT NULL,
    failed_attempts integer DEFAULT 0 NOT NULL,
    last_request_at timestamp without time zone,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    login character varying(255),
    ship_address_id integer,
    bill_address_id integer,
    authentication_token character varying(255),
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    reset_password_sent_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    spree_api_key character varying(48),
    remember_created_at timestamp without time zone,
    first_name character varying(255),
    last_name character varying(255),
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    sign_up_via integer,
    sign_up_reason character varying(255),
    phone character varying(255),
    newsletter boolean,
    last_cart_notification_sent_at timestamp without time zone,
    last_wishlist_notification_sent_at timestamp without time zone,
    last_quiz_notification_sent_at timestamp without time zone,
    site_version_id integer,
    dob date,
    last_payment_failed_notification_sent_at timestamp without time zone,
    birthday date,
    automagically_registered boolean DEFAULT false,
    active_moodboard_id integer,
    wedding_atelier_signup_step character varying(255) DEFAULT 'size'::character varying,
    user_data text DEFAULT '{}'::text NOT NULL
);


--
-- Name: spree_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_users_id_seq OWNED BY public.spree_users.id;


--
-- Name: spree_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_variants (
    id integer NOT NULL,
    sku character varying(255) DEFAULT ''::character varying NOT NULL,
    weight numeric(8,2),
    height numeric(8,2),
    width numeric(8,2),
    depth numeric(8,2),
    deleted_at timestamp without time zone,
    is_master boolean DEFAULT false,
    product_id integer,
    count_on_hand integer DEFAULT 0,
    cost_price numeric(8,2),
    "position" integer,
    lock_version integer DEFAULT 0,
    on_demand boolean DEFAULT false,
    cost_currency character varying(255)
);


--
-- Name: spree_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_variants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_variants_id_seq OWNED BY public.spree_variants.id;


--
-- Name: spree_zone_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_zone_members (
    id integer NOT NULL,
    zoneable_id integer,
    zoneable_type character varying(255),
    zone_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    has_international_shipping_fee boolean DEFAULT false,
    show_duty_fee_notification boolean DEFAULT false
);


--
-- Name: spree_zone_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_zone_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_zone_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_zone_members_id_seq OWNED BY public.spree_zone_members.id;


--
-- Name: spree_zones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spree_zones (
    id integer NOT NULL,
    name character varying(255),
    description character varying(255),
    default_tax boolean DEFAULT false,
    zone_members_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: spree_zones_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spree_zones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spree_zones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spree_zones_id_seq OWNED BY public.spree_zones.id;


--
-- Name: style_to_product_height_range_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.style_to_product_height_range_groups (
    id integer NOT NULL,
    style_number character varying(255),
    product_height_range_group_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: style_to_product_height_range_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.style_to_product_height_range_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: style_to_product_height_range_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.style_to_product_height_range_groups_id_seq OWNED BY public.style_to_product_height_range_groups.id;


--
-- Name: styles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.styles (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying(255)
);


--
-- Name: styles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.styles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: styles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.styles_id_seq OWNED BY public.styles.id;


--
-- Name: user_style_profile_taxons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_style_profile_taxons (
    id integer NOT NULL,
    user_style_profile_id integer,
    taxon_id integer,
    capacity integer
);


--
-- Name: user_style_profile_taxons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_style_profile_taxons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_style_profile_taxons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_style_profile_taxons_id_seq OWNED BY public.user_style_profile_taxons.id;


--
-- Name: user_style_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_style_profiles (
    id integer NOT NULL,
    user_id integer,
    glam double precision,
    girly double precision,
    classic double precision,
    edgy double precision,
    bohemian double precision,
    sexiness double precision,
    fashionability double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    nail_colours character varying(255),
    brands character varying(255),
    trends character varying(255),
    hair_colour character varying(255),
    skin_colour character varying(255),
    body_shape character varying(255),
    typical_size character varying(255),
    bra_size character varying(255),
    colours character varying(255),
    serialized_answers text
);


--
-- Name: user_style_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_style_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_style_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_style_profiles_id_seq OWNED BY public.user_style_profiles.id;


--
-- Name: wedding_atelier_event_assistants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_event_assistants (
    id integer NOT NULL,
    user_id integer,
    event_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wedding_atelier_event_assistants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_atelier_event_assistants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_atelier_event_assistants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_atelier_event_assistants_id_seq OWNED BY public.wedding_atelier_event_assistants.id;


--
-- Name: wedding_atelier_event_dresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_event_dresses (
    id integer NOT NULL,
    product_id integer,
    event_id integer,
    user_id integer,
    color_id integer,
    style_id integer,
    fabric_id integer,
    size_id integer,
    length_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fit_id integer,
    height character varying(255),
    likes_count integer DEFAULT 0
);


--
-- Name: wedding_atelier_event_dresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_atelier_event_dresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_atelier_event_dresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_atelier_event_dresses_id_seq OWNED BY public.wedding_atelier_event_dresses.id;


--
-- Name: wedding_atelier_event_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_event_roles (
    id integer NOT NULL,
    name character varying(255),
    resource_id integer,
    resource_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wedding_atelier_event_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_atelier_event_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_atelier_event_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_atelier_event_roles_id_seq OWNED BY public.wedding_atelier_event_roles.id;


--
-- Name: wedding_atelier_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_events (
    id integer NOT NULL,
    event_type character varying(255),
    number_of_assistants integer,
    date date,
    name character varying(255),
    slug character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    owner_id integer
);


--
-- Name: wedding_atelier_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_atelier_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_atelier_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_atelier_events_id_seq OWNED BY public.wedding_atelier_events.id;


--
-- Name: wedding_atelier_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_invitations (
    id integer NOT NULL,
    user_email character varying(255),
    event_slug character varying(255),
    state character varying(255) DEFAULT 'pending'::character varying,
    event_id integer,
    inviter_id integer
);


--
-- Name: wedding_atelier_invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_atelier_invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_atelier_invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_atelier_invitations_id_seq OWNED BY public.wedding_atelier_invitations.id;


--
-- Name: wedding_atelier_likes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_likes (
    id integer NOT NULL,
    user_id integer,
    event_dress_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wedding_atelier_likes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_atelier_likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_atelier_likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_atelier_likes_id_seq OWNED BY public.wedding_atelier_likes.id;


--
-- Name: wedding_atelier_user_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_user_profiles (
    id integer NOT NULL,
    spree_user_id integer,
    height character varying(255),
    trend_updates boolean,
    dress_size_id integer
);


--
-- Name: wedding_atelier_user_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_atelier_user_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_atelier_user_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_atelier_user_profiles_id_seq OWNED BY public.wedding_atelier_user_profiles.id;


--
-- Name: wedding_atelier_users_event_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_atelier_users_event_roles (
    user_id integer,
    event_role_id integer
);


--
-- Name: wedding_plannings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wedding_plannings (
    id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    phone character varying(255),
    preferred_time character varying(255),
    session_type character varying(255),
    should_contact boolean,
    should_receive_trend_updates boolean,
    timezone character varying(255),
    wedding_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: wedding_plannings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wedding_plannings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wedding_plannings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wedding_plannings_id_seq OWNED BY public.wedding_plannings.id;


--
-- Name: wishlist_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wishlist_items (
    id integer NOT NULL,
    spree_user_id integer,
    spree_variant_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quantity integer DEFAULT 1,
    spree_product_id integer,
    product_color_id integer
);


--
-- Name: wishlist_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.wishlist_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wishlist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.wishlist_items_id_seq OWNED BY public.wishlist_items.id;


--
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: answer_taxons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer_taxons ALTER COLUMN id SET DEFAULT nextval('public.answer_taxons_id_seq'::regclass);


--
-- Name: answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers ALTER COLUMN id SET DEFAULT nextval('public.answers_id_seq'::regclass);


--
-- Name: batch_collection_line_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_collection_line_items ALTER COLUMN id SET DEFAULT nextval('public.batch_collection_line_items_id_seq'::regclass);


--
-- Name: batch_collections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_collections ALTER COLUMN id SET DEFAULT nextval('public.batch_collections_id_seq'::regclass);


--
-- Name: bergen_return_item_processes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bergen_return_item_processes ALTER COLUMN id SET DEFAULT nextval('public.bergen_return_item_processes_id_seq'::regclass);


--
-- Name: bulk_order_updates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_order_updates ALTER COLUMN id SET DEFAULT nextval('public.bulk_order_updates_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: celebrity_inspirations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.celebrity_inspirations ALTER COLUMN id SET DEFAULT nextval('public.celebrity_inspirations_id_seq'::regclass);


--
-- Name: competition_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competition_entries ALTER COLUMN id SET DEFAULT nextval('public.competition_entries_id_seq'::regclass);


--
-- Name: competition_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competition_invitations ALTER COLUMN id SET DEFAULT nextval('public.competition_invitations_id_seq'::regclass);


--
-- Name: competition_participations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competition_participations ALTER COLUMN id SET DEFAULT nextval('public.competition_participations_id_seq'::regclass);


--
-- Name: contentful_routes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentful_routes ALTER COLUMN id SET DEFAULT nextval('public.contentful_routes_id_seq'::regclass);


--
-- Name: contentful_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentful_versions ALTER COLUMN id SET DEFAULT nextval('public.contentful_versions_id_seq'::regclass);


--
-- Name: curations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.curations ALTER COLUMN id SET DEFAULT nextval('public.curations_id_seq'::regclass);


--
-- Name: custom_dress_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_dress_images ALTER COLUMN id SET DEFAULT nextval('public.custom_dress_images_id_seq'::regclass);


--
-- Name: custom_dresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_dresses ALTER COLUMN id SET DEFAULT nextval('public.custom_dresses_id_seq'::regclass);


--
-- Name: customisation_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customisation_values ALTER COLUMN id SET DEFAULT nextval('public.customisation_values_id_seq'::regclass);


--
-- Name: customization_visualizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customization_visualizations ALTER COLUMN id SET DEFAULT nextval('public.customization_visualizations_id_seq'::regclass);


--
-- Name: discounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts ALTER COLUMN id SET DEFAULT nextval('public.discounts_id_seq'::regclass);


--
-- Name: email_notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_notifications ALTER COLUMN id SET DEFAULT nextval('public.email_notifications_id_seq'::regclass);


--
-- Name: fabric_card_colours id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabric_card_colours ALTER COLUMN id SET DEFAULT nextval('public.fabric_card_colours_id_seq'::regclass);


--
-- Name: fabric_cards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabric_cards ALTER COLUMN id SET DEFAULT nextval('public.fabric_cards_id_seq'::regclass);


--
-- Name: fabric_colours id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabric_colours ALTER COLUMN id SET DEFAULT nextval('public.fabric_colours_id_seq'::regclass);


--
-- Name: fabrication_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrication_events ALTER COLUMN id SET DEFAULT nextval('public.fabrication_events_id_seq'::regclass);


--
-- Name: fabrications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrications ALTER COLUMN id SET DEFAULT nextval('public.fabrications_id_seq'::regclass);


--
-- Name: fabrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrics ALTER COLUMN id SET DEFAULT nextval('public.fabrics_id_seq'::regclass);


--
-- Name: fabrics_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrics_products ALTER COLUMN id SET DEFAULT nextval('public.fabrics_products_id_seq'::regclass);


--
-- Name: facebook_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_accounts ALTER COLUMN id SET DEFAULT nextval('public.facebook_accounts_id_seq'::regclass);


--
-- Name: facebook_ad_creatives id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_ad_creatives ALTER COLUMN id SET DEFAULT nextval('public.facebook_ad_creatives_id_seq'::regclass);


--
-- Name: facebook_ad_insights id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_ad_insights ALTER COLUMN id SET DEFAULT nextval('public.facebook_ad_insights_id_seq'::regclass);


--
-- Name: facebook_ads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_ads ALTER COLUMN id SET DEFAULT nextval('public.facebook_ads_id_seq'::regclass);


--
-- Name: facebook_adsets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_adsets ALTER COLUMN id SET DEFAULT nextval('public.facebook_adsets_id_seq'::regclass);


--
-- Name: facebook_campaigns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_campaigns ALTER COLUMN id SET DEFAULT nextval('public.facebook_campaigns_id_seq'::regclass);


--
-- Name: facebook_data id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_data ALTER COLUMN id SET DEFAULT nextval('public.facebook_data_id_seq'::regclass);


--
-- Name: factories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.factories ALTER COLUMN id SET DEFAULT nextval('public.factories_id_seq'::regclass);


--
-- Name: global_skus id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_skus ALTER COLUMN id SET DEFAULT nextval('public.global_skus_id_seq'::regclass);


--
-- Name: incompatibilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incompatibilities ALTER COLUMN id SET DEFAULT nextval('public.incompatibilities_id_seq'::regclass);


--
-- Name: inspirations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inspirations ALTER COLUMN id SET DEFAULT nextval('public.inspirations_id_seq'::regclass);


--
-- Name: item_return_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_return_events ALTER COLUMN id SET DEFAULT nextval('public.item_return_events_id_seq'::regclass);


--
-- Name: item_return_labels id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_return_labels ALTER COLUMN id SET DEFAULT nextval('public.item_return_labels_id_seq'::regclass);


--
-- Name: item_returns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_returns ALTER COLUMN id SET DEFAULT nextval('public.item_returns_id_seq'::regclass);


--
-- Name: layer_cads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.layer_cads ALTER COLUMN id SET DEFAULT nextval('public.layer_cads_id_seq'::regclass);


--
-- Name: line_item_making_options id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_making_options ALTER COLUMN id SET DEFAULT nextval('public.line_item_making_options_id_seq'::regclass);


--
-- Name: line_item_personalizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_personalizations ALTER COLUMN id SET DEFAULT nextval('public.line_item_personalizations_id_seq'::regclass);


--
-- Name: line_item_size_normalisations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_size_normalisations ALTER COLUMN id SET DEFAULT nextval('public.line_item_size_normalisations_id_seq'::regclass);


--
-- Name: line_item_updates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_updates ALTER COLUMN id SET DEFAULT nextval('public.line_item_updates_id_seq'::regclass);


--
-- Name: making_options id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.making_options ALTER COLUMN id SET DEFAULT nextval('public.making_options_id_seq'::regclass);


--
-- Name: manually_managed_returns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manually_managed_returns ALTER COLUMN id SET DEFAULT nextval('public.manually_managed_returns_id_seq'::regclass);


--
-- Name: marketing_body_calculator_measures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marketing_body_calculator_measures ALTER COLUMN id SET DEFAULT nextval('public.marketing_body_calculator_measures_id_seq'::regclass);


--
-- Name: marketing_order_traffic_parameters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marketing_order_traffic_parameters ALTER COLUMN id SET DEFAULT nextval('public.marketing_order_traffic_parameters_id_seq'::regclass);


--
-- Name: marketing_user_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marketing_user_visits ALTER COLUMN id SET DEFAULT nextval('public.marketing_user_visits_id_seq'::regclass);


--
-- Name: moodboard_collaborators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_collaborators ALTER COLUMN id SET DEFAULT nextval('public.moodboard_collaborators_id_seq'::regclass);


--
-- Name: moodboard_item_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_item_comments ALTER COLUMN id SET DEFAULT nextval('public.moodboard_item_comments_id_seq'::regclass);


--
-- Name: moodboard_item_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_item_events ALTER COLUMN id SET DEFAULT nextval('public.moodboard_item_events_id_seq'::regclass);


--
-- Name: moodboard_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_items ALTER COLUMN id SET DEFAULT nextval('public.moodboard_items_id_seq'::regclass);


--
-- Name: moodboards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboards ALTER COLUMN id SET DEFAULT nextval('public.moodboards_id_seq'::regclass);


--
-- Name: newgistics_schedulers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newgistics_schedulers ALTER COLUMN id SET DEFAULT nextval('public.newgistics_schedulers_id_seq'::regclass);


--
-- Name: next_logistics_return_request_processes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.next_logistics_return_request_processes ALTER COLUMN id SET DEFAULT nextval('public.next_logistics_return_request_processes_id_seq'::regclass);


--
-- Name: old_variant_taxons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.old_variant_taxons ALTER COLUMN id SET DEFAULT nextval('public.old_variant_taxons_id_seq'::regclass);


--
-- Name: order_return_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_return_requests ALTER COLUMN id SET DEFAULT nextval('public.order_return_requests_id_seq'::regclass);


--
-- Name: payment_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_requests ALTER COLUMN id SET DEFAULT nextval('public.payment_requests_id_seq'::regclass);


--
-- Name: product_accessories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_accessories ALTER COLUMN id SET DEFAULT nextval('public.product_accessories_id_seq'::regclass);


--
-- Name: product_color_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_color_values ALTER COLUMN id SET DEFAULT nextval('public.product_color_values_id_seq'::regclass);


--
-- Name: product_height_range_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_height_range_groups ALTER COLUMN id SET DEFAULT nextval('public.product_height_range_groups_id_seq'::regclass);


--
-- Name: product_height_ranges id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_height_ranges ALTER COLUMN id SET DEFAULT nextval('public.product_height_ranges_id_seq'::regclass);


--
-- Name: product_making_options id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_making_options ALTER COLUMN id SET DEFAULT nextval('public.product_making_options_id_seq'::regclass);


--
-- Name: product_personalizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_personalizations ALTER COLUMN id SET DEFAULT nextval('public.product_personalizations_id_seq'::regclass);


--
-- Name: product_reservations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_reservations ALTER COLUMN id SET DEFAULT nextval('public.product_reservations_id_seq'::regclass);


--
-- Name: product_style_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_style_profiles ALTER COLUMN id SET DEFAULT nextval('public.product_style_profiles_id_seq'::regclass);


--
-- Name: questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions ALTER COLUMN id SET DEFAULT nextval('public.questions_id_seq'::regclass);


--
-- Name: quizzes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes ALTER COLUMN id SET DEFAULT nextval('public.quizzes_id_seq'::regclass);


--
-- Name: redirected_search_terms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirected_search_terms ALTER COLUMN id SET DEFAULT nextval('public.redirected_search_terms_id_seq'::regclass);


--
-- Name: refund_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refund_requests ALTER COLUMN id SET DEFAULT nextval('public.refund_requests_id_seq'::regclass);


--
-- Name: render3d_images id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.render3d_images ALTER COLUMN id SET DEFAULT nextval('public.render3d_images_id_seq'::regclass);


--
-- Name: return_inventory_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_inventory_items ALTER COLUMN id SET DEFAULT nextval('public.return_inventory_items_id_seq'::regclass);


--
-- Name: return_request_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_request_items ALTER COLUMN id SET DEFAULT nextval('public.return_request_items_id_seq'::regclass);


--
-- Name: revolution_pages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revolution_pages ALTER COLUMN id SET DEFAULT nextval('public.revolution_pages_id_seq'::regclass);


--
-- Name: revolution_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revolution_translations ALTER COLUMN id SET DEFAULT nextval('public.revolution_translations_id_seq'::regclass);


--
-- Name: similarities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.similarities ALTER COLUMN id SET DEFAULT nextval('public.similarities_id_seq'::regclass);


--
-- Name: simple_key_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.simple_key_values ALTER COLUMN id SET DEFAULT nextval('public.simple_key_values_id_seq'::regclass);


--
-- Name: site_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_versions ALTER COLUMN id SET DEFAULT nextval('public.site_versions_id_seq'::regclass);


--
-- Name: spree_activators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_activators ALTER COLUMN id SET DEFAULT nextval('public.spree_activators_id_seq'::regclass);


--
-- Name: spree_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_addresses ALTER COLUMN id SET DEFAULT nextval('public.spree_addresses_id_seq'::regclass);


--
-- Name: spree_adjustments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_adjustments ALTER COLUMN id SET DEFAULT nextval('public.spree_adjustments_id_seq'::regclass);


--
-- Name: spree_assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_assets ALTER COLUMN id SET DEFAULT nextval('public.spree_assets_id_seq'::regclass);


--
-- Name: spree_authentication_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_authentication_methods ALTER COLUMN id SET DEFAULT nextval('public.spree_authentication_methods_id_seq'::regclass);


--
-- Name: spree_banner_boxes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_banner_boxes ALTER COLUMN id SET DEFAULT nextval('public.spree_banner_boxes_id_seq'::regclass);


--
-- Name: spree_calculators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_calculators ALTER COLUMN id SET DEFAULT nextval('public.spree_calculators_id_seq'::regclass);


--
-- Name: spree_configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_configurations ALTER COLUMN id SET DEFAULT nextval('public.spree_configurations_id_seq'::regclass);


--
-- Name: spree_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_countries ALTER COLUMN id SET DEFAULT nextval('public.spree_countries_id_seq'::regclass);


--
-- Name: spree_credit_cards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_credit_cards ALTER COLUMN id SET DEFAULT nextval('public.spree_credit_cards_id_seq'::regclass);


--
-- Name: spree_gateways id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_gateways ALTER COLUMN id SET DEFAULT nextval('public.spree_gateways_id_seq'::regclass);


--
-- Name: spree_inventory_units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_inventory_units ALTER COLUMN id SET DEFAULT nextval('public.spree_inventory_units_id_seq'::regclass);


--
-- Name: spree_line_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_line_items ALTER COLUMN id SET DEFAULT nextval('public.spree_line_items_id_seq'::regclass);


--
-- Name: spree_log_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_log_entries ALTER COLUMN id SET DEFAULT nextval('public.spree_log_entries_id_seq'::regclass);


--
-- Name: spree_mail_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_mail_methods ALTER COLUMN id SET DEFAULT nextval('public.spree_mail_methods_id_seq'::regclass);


--
-- Name: spree_masterpass_checkouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_masterpass_checkouts ALTER COLUMN id SET DEFAULT nextval('public.spree_masterpass_checkouts_id_seq'::regclass);


--
-- Name: spree_option_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_option_types ALTER COLUMN id SET DEFAULT nextval('public.spree_option_types_id_seq'::regclass);


--
-- Name: spree_option_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_option_values ALTER COLUMN id SET DEFAULT nextval('public.spree_option_values_id_seq'::regclass);


--
-- Name: spree_option_values_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_option_values_groups ALTER COLUMN id SET DEFAULT nextval('public.spree_option_values_groups_id_seq'::regclass);


--
-- Name: spree_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_orders ALTER COLUMN id SET DEFAULT nextval('public.spree_orders_id_seq'::regclass);


--
-- Name: spree_payment_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_payment_methods ALTER COLUMN id SET DEFAULT nextval('public.spree_payment_methods_id_seq'::regclass);


--
-- Name: spree_payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_payments ALTER COLUMN id SET DEFAULT nextval('public.spree_payments_id_seq'::regclass);


--
-- Name: spree_paypal_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_paypal_accounts ALTER COLUMN id SET DEFAULT nextval('public.spree_paypal_accounts_id_seq'::regclass);


--
-- Name: spree_paypal_express_checkouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_paypal_express_checkouts ALTER COLUMN id SET DEFAULT nextval('public.spree_paypal_express_checkouts_id_seq'::regclass);


--
-- Name: spree_preferences id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_preferences ALTER COLUMN id SET DEFAULT nextval('public.spree_preferences_id_seq'::regclass);


--
-- Name: spree_prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_prices ALTER COLUMN id SET DEFAULT nextval('public.spree_prices_id_seq'::regclass);


--
-- Name: spree_product_option_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_product_option_types ALTER COLUMN id SET DEFAULT nextval('public.spree_product_option_types_id_seq'::regclass);


--
-- Name: spree_product_properties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_product_properties ALTER COLUMN id SET DEFAULT nextval('public.spree_product_properties_id_seq'::regclass);


--
-- Name: spree_product_related_outerwear id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_product_related_outerwear ALTER COLUMN id SET DEFAULT nextval('public.spree_product_related_outerwear_id_seq'::regclass);


--
-- Name: spree_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_products ALTER COLUMN id SET DEFAULT nextval('public.spree_products_id_seq'::regclass);


--
-- Name: spree_products_taxons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_products_taxons ALTER COLUMN id SET DEFAULT nextval('public.spree_products_taxons_id_seq'::regclass);


--
-- Name: spree_promotion_action_line_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_promotion_action_line_items ALTER COLUMN id SET DEFAULT nextval('public.spree_promotion_action_line_items_id_seq'::regclass);


--
-- Name: spree_promotion_actions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_promotion_actions ALTER COLUMN id SET DEFAULT nextval('public.spree_promotion_actions_id_seq'::regclass);


--
-- Name: spree_promotion_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_promotion_rules ALTER COLUMN id SET DEFAULT nextval('public.spree_promotion_rules_id_seq'::regclass);


--
-- Name: spree_properties id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_properties ALTER COLUMN id SET DEFAULT nextval('public.spree_properties_id_seq'::regclass);


--
-- Name: spree_prototypes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_prototypes ALTER COLUMN id SET DEFAULT nextval('public.spree_prototypes_id_seq'::regclass);


--
-- Name: spree_return_authorizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_return_authorizations ALTER COLUMN id SET DEFAULT nextval('public.spree_return_authorizations_id_seq'::regclass);


--
-- Name: spree_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_roles ALTER COLUMN id SET DEFAULT nextval('public.spree_roles_id_seq'::regclass);


--
-- Name: spree_sales id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_sales ALTER COLUMN id SET DEFAULT nextval('public.spree_sales_id_seq'::regclass);


--
-- Name: spree_shipments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_shipments ALTER COLUMN id SET DEFAULT nextval('public.spree_shipments_id_seq'::regclass);


--
-- Name: spree_shipping_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_shipping_categories ALTER COLUMN id SET DEFAULT nextval('public.spree_shipping_categories_id_seq'::regclass);


--
-- Name: spree_shipping_methods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_shipping_methods ALTER COLUMN id SET DEFAULT nextval('public.spree_shipping_methods_id_seq'::regclass);


--
-- Name: spree_skrill_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_skrill_transactions ALTER COLUMN id SET DEFAULT nextval('public.spree_skrill_transactions_id_seq'::regclass);


--
-- Name: spree_state_changes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_state_changes ALTER COLUMN id SET DEFAULT nextval('public.spree_state_changes_id_seq'::regclass);


--
-- Name: spree_states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_states ALTER COLUMN id SET DEFAULT nextval('public.spree_states_id_seq'::regclass);


--
-- Name: spree_tax_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_tax_categories ALTER COLUMN id SET DEFAULT nextval('public.spree_tax_categories_id_seq'::regclass);


--
-- Name: spree_tax_rates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_tax_rates ALTER COLUMN id SET DEFAULT nextval('public.spree_tax_rates_id_seq'::regclass);


--
-- Name: spree_taxon_banners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_taxon_banners ALTER COLUMN id SET DEFAULT nextval('public.spree_taxon_banners_id_seq'::regclass);


--
-- Name: spree_taxonomies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_taxonomies ALTER COLUMN id SET DEFAULT nextval('public.spree_taxonomies_id_seq'::regclass);


--
-- Name: spree_taxons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_taxons ALTER COLUMN id SET DEFAULT nextval('public.spree_taxons_id_seq'::regclass);


--
-- Name: spree_tokenized_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_tokenized_permissions ALTER COLUMN id SET DEFAULT nextval('public.spree_tokenized_permissions_id_seq'::regclass);


--
-- Name: spree_trackers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_trackers ALTER COLUMN id SET DEFAULT nextval('public.spree_trackers_id_seq'::regclass);


--
-- Name: spree_user_authentications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_user_authentications ALTER COLUMN id SET DEFAULT nextval('public.spree_user_authentications_id_seq'::regclass);


--
-- Name: spree_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_users ALTER COLUMN id SET DEFAULT nextval('public.spree_users_id_seq'::regclass);


--
-- Name: spree_variants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_variants ALTER COLUMN id SET DEFAULT nextval('public.spree_variants_id_seq'::regclass);


--
-- Name: spree_zone_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_zone_members ALTER COLUMN id SET DEFAULT nextval('public.spree_zone_members_id_seq'::regclass);


--
-- Name: spree_zones id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_zones ALTER COLUMN id SET DEFAULT nextval('public.spree_zones_id_seq'::regclass);


--
-- Name: style_to_product_height_range_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.style_to_product_height_range_groups ALTER COLUMN id SET DEFAULT nextval('public.style_to_product_height_range_groups_id_seq'::regclass);


--
-- Name: styles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.styles ALTER COLUMN id SET DEFAULT nextval('public.styles_id_seq'::regclass);


--
-- Name: user_style_profile_taxons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_style_profile_taxons ALTER COLUMN id SET DEFAULT nextval('public.user_style_profile_taxons_id_seq'::regclass);


--
-- Name: user_style_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_style_profiles ALTER COLUMN id SET DEFAULT nextval('public.user_style_profiles_id_seq'::regclass);


--
-- Name: wedding_atelier_event_assistants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_event_assistants ALTER COLUMN id SET DEFAULT nextval('public.wedding_atelier_event_assistants_id_seq'::regclass);


--
-- Name: wedding_atelier_event_dresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_event_dresses ALTER COLUMN id SET DEFAULT nextval('public.wedding_atelier_event_dresses_id_seq'::regclass);


--
-- Name: wedding_atelier_event_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_event_roles ALTER COLUMN id SET DEFAULT nextval('public.wedding_atelier_event_roles_id_seq'::regclass);


--
-- Name: wedding_atelier_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_events ALTER COLUMN id SET DEFAULT nextval('public.wedding_atelier_events_id_seq'::regclass);


--
-- Name: wedding_atelier_invitations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_invitations ALTER COLUMN id SET DEFAULT nextval('public.wedding_atelier_invitations_id_seq'::regclass);


--
-- Name: wedding_atelier_likes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_likes ALTER COLUMN id SET DEFAULT nextval('public.wedding_atelier_likes_id_seq'::regclass);


--
-- Name: wedding_atelier_user_profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_user_profiles ALTER COLUMN id SET DEFAULT nextval('public.wedding_atelier_user_profiles_id_seq'::regclass);


--
-- Name: wedding_plannings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_plannings ALTER COLUMN id SET DEFAULT nextval('public.wedding_plannings_id_seq'::regclass);


--
-- Name: wishlist_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlist_items ALTER COLUMN id SET DEFAULT nextval('public.wishlist_items_id_seq'::regclass);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: answer_taxons answer_taxons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer_taxons
    ADD CONSTRAINT answer_taxons_pkey PRIMARY KEY (id);


--
-- Name: answers answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


--
-- Name: spree_banner_boxes banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_banner_boxes
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: batch_collection_line_items batch_collection_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_collection_line_items
    ADD CONSTRAINT batch_collection_line_items_pkey PRIMARY KEY (id);


--
-- Name: batch_collections batch_collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.batch_collections
    ADD CONSTRAINT batch_collections_pkey PRIMARY KEY (id);


--
-- Name: bergen_return_item_processes bergen_return_item_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bergen_return_item_processes
    ADD CONSTRAINT bergen_return_item_processes_pkey PRIMARY KEY (id);


--
-- Name: bulk_order_updates bulk_order_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bulk_order_updates
    ADD CONSTRAINT bulk_order_updates_pkey PRIMARY KEY (id);


--
-- Name: celebrity_inspirations celebrity_inspirations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.celebrity_inspirations
    ADD CONSTRAINT celebrity_inspirations_pkey PRIMARY KEY (id);


--
-- Name: categories classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT classifications_pkey PRIMARY KEY (id);


--
-- Name: competition_entries competition_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competition_entries
    ADD CONSTRAINT competition_entries_pkey PRIMARY KEY (id);


--
-- Name: competition_invitations competition_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competition_invitations
    ADD CONSTRAINT competition_invitations_pkey PRIMARY KEY (id);


--
-- Name: competition_participations competition_participations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.competition_participations
    ADD CONSTRAINT competition_participations_pkey PRIMARY KEY (id);


--
-- Name: contentful_routes contentful_routes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentful_routes
    ADD CONSTRAINT contentful_routes_pkey PRIMARY KEY (id);


--
-- Name: contentful_versions contentful_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contentful_versions
    ADD CONSTRAINT contentful_versions_pkey PRIMARY KEY (id);


--
-- Name: curations curations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.curations
    ADD CONSTRAINT curations_pkey PRIMARY KEY (id);


--
-- Name: custom_dress_images custom_dress_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_dress_images
    ADD CONSTRAINT custom_dress_images_pkey PRIMARY KEY (id);


--
-- Name: custom_dresses custom_dresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_dresses
    ADD CONSTRAINT custom_dresses_pkey PRIMARY KEY (id);


--
-- Name: customisation_values customisation_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customisation_values
    ADD CONSTRAINT customisation_values_pkey PRIMARY KEY (id);


--
-- Name: customization_visualizations customization_visualizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customization_visualizations
    ADD CONSTRAINT customization_visualizations_pkey PRIMARY KEY (id);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (id);


--
-- Name: email_notifications email_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email_notifications
    ADD CONSTRAINT email_notifications_pkey PRIMARY KEY (id);


--
-- Name: fabric_card_colours fabric_card_colours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabric_card_colours
    ADD CONSTRAINT fabric_card_colours_pkey PRIMARY KEY (id);


--
-- Name: fabric_cards fabric_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabric_cards
    ADD CONSTRAINT fabric_cards_pkey PRIMARY KEY (id);


--
-- Name: fabric_colours fabric_colours_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabric_colours
    ADD CONSTRAINT fabric_colours_pkey PRIMARY KEY (id);


--
-- Name: fabrication_events fabrication_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrication_events
    ADD CONSTRAINT fabrication_events_pkey PRIMARY KEY (id);


--
-- Name: fabrications fabrications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrications
    ADD CONSTRAINT fabrications_pkey PRIMARY KEY (id);


--
-- Name: fabrics fabrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrics
    ADD CONSTRAINT fabrics_pkey PRIMARY KEY (id);


--
-- Name: fabrics_products fabrics_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fabrics_products
    ADD CONSTRAINT fabrics_products_pkey PRIMARY KEY (id);


--
-- Name: facebook_accounts facebook_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_accounts
    ADD CONSTRAINT facebook_accounts_pkey PRIMARY KEY (id);


--
-- Name: facebook_ad_creatives facebook_ad_creatives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_ad_creatives
    ADD CONSTRAINT facebook_ad_creatives_pkey PRIMARY KEY (id);


--
-- Name: facebook_ad_insights facebook_ad_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_ad_insights
    ADD CONSTRAINT facebook_ad_insights_pkey PRIMARY KEY (id);


--
-- Name: facebook_ads facebook_ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_ads
    ADD CONSTRAINT facebook_ads_pkey PRIMARY KEY (id);


--
-- Name: facebook_adsets facebook_adsets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_adsets
    ADD CONSTRAINT facebook_adsets_pkey PRIMARY KEY (id);


--
-- Name: facebook_campaigns facebook_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_campaigns
    ADD CONSTRAINT facebook_campaigns_pkey PRIMARY KEY (id);


--
-- Name: facebook_data facebook_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.facebook_data
    ADD CONSTRAINT facebook_data_pkey PRIMARY KEY (id);


--
-- Name: factories factories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.factories
    ADD CONSTRAINT factories_pkey PRIMARY KEY (id);


--
-- Name: global_skus global_skus_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_skus
    ADD CONSTRAINT global_skus_pkey PRIMARY KEY (id);


--
-- Name: incompatibilities incompatibilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.incompatibilities
    ADD CONSTRAINT incompatibilities_pkey PRIMARY KEY (id);


--
-- Name: item_return_events item_return_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_return_events
    ADD CONSTRAINT item_return_events_pkey PRIMARY KEY (id);


--
-- Name: item_return_labels item_return_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_return_labels
    ADD CONSTRAINT item_return_labels_pkey PRIMARY KEY (id);


--
-- Name: item_returns item_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_returns
    ADD CONSTRAINT item_returns_pkey PRIMARY KEY (id);


--
-- Name: layer_cads layer_cads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.layer_cads
    ADD CONSTRAINT layer_cads_pkey PRIMARY KEY (id);


--
-- Name: line_item_making_options line_item_making_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_making_options
    ADD CONSTRAINT line_item_making_options_pkey PRIMARY KEY (id);


--
-- Name: line_item_personalizations line_item_personalizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_personalizations
    ADD CONSTRAINT line_item_personalizations_pkey PRIMARY KEY (id);


--
-- Name: line_item_size_normalisations line_item_size_normalisations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_size_normalisations
    ADD CONSTRAINT line_item_size_normalisations_pkey PRIMARY KEY (id);


--
-- Name: line_item_updates line_item_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_updates
    ADD CONSTRAINT line_item_updates_pkey PRIMARY KEY (id);


--
-- Name: making_options making_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.making_options
    ADD CONSTRAINT making_options_pkey PRIMARY KEY (id);


--
-- Name: manually_managed_returns manually_managed_returns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.manually_managed_returns
    ADD CONSTRAINT manually_managed_returns_pkey PRIMARY KEY (id);


--
-- Name: marketing_body_calculator_measures marketing_body_calculator_measures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marketing_body_calculator_measures
    ADD CONSTRAINT marketing_body_calculator_measures_pkey PRIMARY KEY (id);


--
-- Name: marketing_order_traffic_parameters marketing_order_traffic_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marketing_order_traffic_parameters
    ADD CONSTRAINT marketing_order_traffic_parameters_pkey PRIMARY KEY (id);


--
-- Name: marketing_user_visits marketing_user_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.marketing_user_visits
    ADD CONSTRAINT marketing_user_visits_pkey PRIMARY KEY (id);


--
-- Name: moodboard_collaborators moodboard_collaborators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_collaborators
    ADD CONSTRAINT moodboard_collaborators_pkey PRIMARY KEY (id);


--
-- Name: moodboard_item_comments moodboard_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_item_comments
    ADD CONSTRAINT moodboard_comments_pkey PRIMARY KEY (id);


--
-- Name: moodboard_item_events moodboard_item_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_item_events
    ADD CONSTRAINT moodboard_item_events_pkey PRIMARY KEY (id);


--
-- Name: inspirations moodboard_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inspirations
    ADD CONSTRAINT moodboard_items_pkey PRIMARY KEY (id);


--
-- Name: moodboard_items moodboard_items_pkey1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboard_items
    ADD CONSTRAINT moodboard_items_pkey1 PRIMARY KEY (id);


--
-- Name: moodboards moodboards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.moodboards
    ADD CONSTRAINT moodboards_pkey PRIMARY KEY (id);


--
-- Name: newgistics_schedulers newgistics_schedulers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.newgistics_schedulers
    ADD CONSTRAINT newgistics_schedulers_pkey PRIMARY KEY (id);


--
-- Name: next_logistics_return_request_processes next_logistics_return_request_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.next_logistics_return_request_processes
    ADD CONSTRAINT next_logistics_return_request_processes_pkey PRIMARY KEY (id);


--
-- Name: order_return_requests order_return_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_return_requests
    ADD CONSTRAINT order_return_requests_pkey PRIMARY KEY (id);


--
-- Name: order_shipments_factories_concrete order_shipments_factories_concrete_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_shipments_factories_concrete
    ADD CONSTRAINT order_shipments_factories_concrete_pkey PRIMARY KEY (id);


--
-- Name: payment_requests payment_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payment_requests
    ADD CONSTRAINT payment_requests_pkey PRIMARY KEY (id);


--
-- Name: spree_paypal_accounts paypal_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_paypal_accounts
    ADD CONSTRAINT paypal_accounts_pkey PRIMARY KEY (id);


--
-- Name: product_accessories product_accessories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_accessories
    ADD CONSTRAINT product_accessories_pkey PRIMARY KEY (id);


--
-- Name: product_color_values product_color_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_color_values
    ADD CONSTRAINT product_color_values_pkey PRIMARY KEY (id);


--
-- Name: product_height_range_groups product_height_range_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_height_range_groups
    ADD CONSTRAINT product_height_range_groups_pkey PRIMARY KEY (id);


--
-- Name: product_height_ranges product_height_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_height_ranges
    ADD CONSTRAINT product_height_ranges_pkey PRIMARY KEY (id);


--
-- Name: product_making_options product_making_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_making_options
    ADD CONSTRAINT product_making_options_pkey PRIMARY KEY (id);


--
-- Name: product_personalizations product_personalizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_personalizations
    ADD CONSTRAINT product_personalizations_pkey PRIMARY KEY (id);


--
-- Name: product_reservations product_reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_reservations
    ADD CONSTRAINT product_reservations_pkey PRIMARY KEY (id);


--
-- Name: product_style_profiles product_style_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_style_profiles
    ADD CONSTRAINT product_style_profiles_pkey PRIMARY KEY (id);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: quizzes quizzes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quizzes
    ADD CONSTRAINT quizzes_pkey PRIMARY KEY (id);


--
-- Name: redirected_search_terms redirected_search_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.redirected_search_terms
    ADD CONSTRAINT redirected_search_terms_pkey PRIMARY KEY (id);


--
-- Name: refund_requests refund_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.refund_requests
    ADD CONSTRAINT refund_requests_pkey PRIMARY KEY (id);


--
-- Name: render3d_images render3d_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.render3d_images
    ADD CONSTRAINT render3d_images_pkey PRIMARY KEY (id);


--
-- Name: return_inventory_items return_inventory_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_inventory_items
    ADD CONSTRAINT return_inventory_items_pkey PRIMARY KEY (id);


--
-- Name: return_request_items return_request_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.return_request_items
    ADD CONSTRAINT return_request_items_pkey PRIMARY KEY (id);


--
-- Name: revolution_pages revolution_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revolution_pages
    ADD CONSTRAINT revolution_pages_pkey PRIMARY KEY (id);


--
-- Name: revolution_translations revolution_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revolution_translations
    ADD CONSTRAINT revolution_translations_pkey PRIMARY KEY (id);


--
-- Name: similarities similarities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.similarities
    ADD CONSTRAINT similarities_pkey PRIMARY KEY (id);


--
-- Name: simple_key_values simple_key_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.simple_key_values
    ADD CONSTRAINT simple_key_values_pkey PRIMARY KEY (id);


--
-- Name: site_versions site_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.site_versions
    ADD CONSTRAINT site_versions_pkey PRIMARY KEY (id);


--
-- Name: spree_activators spree_activators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_activators
    ADD CONSTRAINT spree_activators_pkey PRIMARY KEY (id);


--
-- Name: spree_addresses spree_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_addresses
    ADD CONSTRAINT spree_addresses_pkey PRIMARY KEY (id);


--
-- Name: spree_adjustments spree_adjustments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_adjustments
    ADD CONSTRAINT spree_adjustments_pkey PRIMARY KEY (id);


--
-- Name: spree_assets spree_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_assets
    ADD CONSTRAINT spree_assets_pkey PRIMARY KEY (id);


--
-- Name: spree_authentication_methods spree_authentication_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_authentication_methods
    ADD CONSTRAINT spree_authentication_methods_pkey PRIMARY KEY (id);


--
-- Name: spree_calculators spree_calculators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_calculators
    ADD CONSTRAINT spree_calculators_pkey PRIMARY KEY (id);


--
-- Name: spree_configurations spree_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_configurations
    ADD CONSTRAINT spree_configurations_pkey PRIMARY KEY (id);


--
-- Name: spree_countries spree_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_countries
    ADD CONSTRAINT spree_countries_pkey PRIMARY KEY (id);


--
-- Name: spree_credit_cards spree_credit_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_credit_cards
    ADD CONSTRAINT spree_credit_cards_pkey PRIMARY KEY (id);


--
-- Name: spree_gateways spree_gateways_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_gateways
    ADD CONSTRAINT spree_gateways_pkey PRIMARY KEY (id);


--
-- Name: spree_inventory_units spree_inventory_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_inventory_units
    ADD CONSTRAINT spree_inventory_units_pkey PRIMARY KEY (id);


--
-- Name: spree_line_items spree_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_line_items
    ADD CONSTRAINT spree_line_items_pkey PRIMARY KEY (id);


--
-- Name: spree_log_entries spree_log_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_log_entries
    ADD CONSTRAINT spree_log_entries_pkey PRIMARY KEY (id);


--
-- Name: spree_mail_methods spree_mail_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_mail_methods
    ADD CONSTRAINT spree_mail_methods_pkey PRIMARY KEY (id);


--
-- Name: spree_masterpass_checkouts spree_masterpass_checkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_masterpass_checkouts
    ADD CONSTRAINT spree_masterpass_checkouts_pkey PRIMARY KEY (id);


--
-- Name: spree_option_types spree_option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_option_types
    ADD CONSTRAINT spree_option_types_pkey PRIMARY KEY (id);


--
-- Name: spree_option_values_groups spree_option_values_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_option_values_groups
    ADD CONSTRAINT spree_option_values_groups_pkey PRIMARY KEY (id);


--
-- Name: spree_option_values spree_option_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_option_values
    ADD CONSTRAINT spree_option_values_pkey PRIMARY KEY (id);


--
-- Name: spree_orders spree_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_orders
    ADD CONSTRAINT spree_orders_pkey PRIMARY KEY (id);


--
-- Name: spree_payment_methods spree_payment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_payment_methods
    ADD CONSTRAINT spree_payment_methods_pkey PRIMARY KEY (id);


--
-- Name: spree_payments spree_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_payments
    ADD CONSTRAINT spree_payments_pkey PRIMARY KEY (id);


--
-- Name: spree_paypal_express_checkouts spree_paypal_express_checkouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_paypal_express_checkouts
    ADD CONSTRAINT spree_paypal_express_checkouts_pkey PRIMARY KEY (id);


--
-- Name: spree_preferences spree_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_preferences
    ADD CONSTRAINT spree_preferences_pkey PRIMARY KEY (id);


--
-- Name: spree_prices spree_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_prices
    ADD CONSTRAINT spree_prices_pkey PRIMARY KEY (id);


--
-- Name: spree_product_option_types spree_product_option_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_product_option_types
    ADD CONSTRAINT spree_product_option_types_pkey PRIMARY KEY (id);


--
-- Name: spree_product_properties spree_product_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_product_properties
    ADD CONSTRAINT spree_product_properties_pkey PRIMARY KEY (id);


--
-- Name: spree_product_related_outerwear spree_product_related_outerwear_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_product_related_outerwear
    ADD CONSTRAINT spree_product_related_outerwear_pkey PRIMARY KEY (id);


--
-- Name: spree_products spree_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_products
    ADD CONSTRAINT spree_products_pkey PRIMARY KEY (id);


--
-- Name: spree_products_taxons spree_products_taxons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_products_taxons
    ADD CONSTRAINT spree_products_taxons_pkey PRIMARY KEY (id);


--
-- Name: spree_promotion_action_line_items spree_promotion_action_line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_promotion_action_line_items
    ADD CONSTRAINT spree_promotion_action_line_items_pkey PRIMARY KEY (id);


--
-- Name: spree_promotion_actions spree_promotion_actions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_promotion_actions
    ADD CONSTRAINT spree_promotion_actions_pkey PRIMARY KEY (id);


--
-- Name: spree_promotion_rules spree_promotion_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_promotion_rules
    ADD CONSTRAINT spree_promotion_rules_pkey PRIMARY KEY (id);


--
-- Name: spree_properties spree_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_properties
    ADD CONSTRAINT spree_properties_pkey PRIMARY KEY (id);


--
-- Name: spree_prototypes spree_prototypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_prototypes
    ADD CONSTRAINT spree_prototypes_pkey PRIMARY KEY (id);


--
-- Name: spree_return_authorizations spree_return_authorizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_return_authorizations
    ADD CONSTRAINT spree_return_authorizations_pkey PRIMARY KEY (id);


--
-- Name: spree_roles spree_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_roles
    ADD CONSTRAINT spree_roles_pkey PRIMARY KEY (id);


--
-- Name: spree_sales spree_sales_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_sales
    ADD CONSTRAINT spree_sales_pkey PRIMARY KEY (id);


--
-- Name: spree_shipments spree_shipments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_shipments
    ADD CONSTRAINT spree_shipments_pkey PRIMARY KEY (id);


--
-- Name: spree_shipping_categories spree_shipping_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_shipping_categories
    ADD CONSTRAINT spree_shipping_categories_pkey PRIMARY KEY (id);


--
-- Name: spree_shipping_methods spree_shipping_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_shipping_methods
    ADD CONSTRAINT spree_shipping_methods_pkey PRIMARY KEY (id);


--
-- Name: spree_skrill_transactions spree_skrill_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_skrill_transactions
    ADD CONSTRAINT spree_skrill_transactions_pkey PRIMARY KEY (id);


--
-- Name: spree_state_changes spree_state_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_state_changes
    ADD CONSTRAINT spree_state_changes_pkey PRIMARY KEY (id);


--
-- Name: spree_states spree_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_states
    ADD CONSTRAINT spree_states_pkey PRIMARY KEY (id);


--
-- Name: spree_tax_categories spree_tax_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_tax_categories
    ADD CONSTRAINT spree_tax_categories_pkey PRIMARY KEY (id);


--
-- Name: spree_tax_rates spree_tax_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_tax_rates
    ADD CONSTRAINT spree_tax_rates_pkey PRIMARY KEY (id);


--
-- Name: spree_taxon_banners spree_taxon_banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_taxon_banners
    ADD CONSTRAINT spree_taxon_banners_pkey PRIMARY KEY (id);


--
-- Name: spree_taxonomies spree_taxonomies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_taxonomies
    ADD CONSTRAINT spree_taxonomies_pkey PRIMARY KEY (id);


--
-- Name: spree_taxons spree_taxons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_taxons
    ADD CONSTRAINT spree_taxons_pkey PRIMARY KEY (id);


--
-- Name: spree_tokenized_permissions spree_tokenized_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_tokenized_permissions
    ADD CONSTRAINT spree_tokenized_permissions_pkey PRIMARY KEY (id);


--
-- Name: spree_trackers spree_trackers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_trackers
    ADD CONSTRAINT spree_trackers_pkey PRIMARY KEY (id);


--
-- Name: spree_user_authentications spree_user_authentications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_user_authentications
    ADD CONSTRAINT spree_user_authentications_pkey PRIMARY KEY (id);


--
-- Name: spree_users spree_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_users
    ADD CONSTRAINT spree_users_pkey PRIMARY KEY (id);


--
-- Name: spree_variants spree_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_variants
    ADD CONSTRAINT spree_variants_pkey PRIMARY KEY (id);


--
-- Name: spree_zone_members spree_zone_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_zone_members
    ADD CONSTRAINT spree_zone_members_pkey PRIMARY KEY (id);


--
-- Name: spree_zones spree_zones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spree_zones
    ADD CONSTRAINT spree_zones_pkey PRIMARY KEY (id);


--
-- Name: user_style_profiles style_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_style_profiles
    ADD CONSTRAINT style_reports_pkey PRIMARY KEY (id);


--
-- Name: style_to_product_height_range_groups style_to_product_height_range_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.style_to_product_height_range_groups
    ADD CONSTRAINT style_to_product_height_range_groups_pkey PRIMARY KEY (id);


--
-- Name: styles styles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.styles
    ADD CONSTRAINT styles_pkey PRIMARY KEY (id);


--
-- Name: user_style_profile_taxons user_style_profile_taxons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_style_profile_taxons
    ADD CONSTRAINT user_style_profile_taxons_pkey PRIMARY KEY (id);


--
-- Name: old_variant_taxons variant_taxons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.old_variant_taxons
    ADD CONSTRAINT variant_taxons_pkey PRIMARY KEY (id);


--
-- Name: wedding_atelier_event_assistants wedding_atelier_event_assistants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_event_assistants
    ADD CONSTRAINT wedding_atelier_event_assistants_pkey PRIMARY KEY (id);


--
-- Name: wedding_atelier_event_dresses wedding_atelier_event_dresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_event_dresses
    ADD CONSTRAINT wedding_atelier_event_dresses_pkey PRIMARY KEY (id);


--
-- Name: wedding_atelier_event_roles wedding_atelier_event_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_event_roles
    ADD CONSTRAINT wedding_atelier_event_roles_pkey PRIMARY KEY (id);


--
-- Name: wedding_atelier_events wedding_atelier_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_events
    ADD CONSTRAINT wedding_atelier_events_pkey PRIMARY KEY (id);


--
-- Name: wedding_atelier_invitations wedding_atelier_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_invitations
    ADD CONSTRAINT wedding_atelier_invitations_pkey PRIMARY KEY (id);


--
-- Name: wedding_atelier_likes wedding_atelier_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_likes
    ADD CONSTRAINT wedding_atelier_likes_pkey PRIMARY KEY (id);


--
-- Name: wedding_atelier_user_profiles wedding_atelier_user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_atelier_user_profiles
    ADD CONSTRAINT wedding_atelier_user_profiles_pkey PRIMARY KEY (id);


--
-- Name: wedding_plannings wedding_plannings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wedding_plannings
    ADD CONSTRAINT wedding_plannings_pkey PRIMARY KEY (id);


--
-- Name: wishlist_items wishlist_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlist_items
    ADD CONSTRAINT wishlist_items_pkey PRIMARY KEY (id);


--
-- Name: dress_features; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dress_features ON public.customization_visualizations USING btree (length, silhouette, neckline);


--
-- Name: email_idx_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX email_idx_unique ON public.spree_users USING btree (email);


--
-- Name: index_activities_on_action; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_action ON public.activities USING btree (action);


--
-- Name: index_activities_on_action_and_owner_type_and_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_action_and_owner_type_and_owner_id ON public.activities USING btree (action, owner_type, owner_id);


--
-- Name: index_activities_on_owner_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_owner_type ON public.activities USING btree (owner_type);


--
-- Name: index_addresses_on_firstname; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_firstname ON public.spree_addresses USING btree (firstname);


--
-- Name: index_addresses_on_lastname; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_addresses_on_lastname ON public.spree_addresses USING btree (lastname);


--
-- Name: index_adjustments_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_adjustments_on_order_id ON public.spree_adjustments USING btree (adjustable_id);


--
-- Name: index_answer_taxons_on_taxon_id_and_answer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answer_taxons_on_taxon_id_and_answer_id ON public.answer_taxons USING btree (taxon_id, answer_id);


--
-- Name: index_answers_on_question_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_answers_on_question_id ON public.answers USING btree (question_id);


--
-- Name: index_assets_on_viewable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_viewable_id ON public.spree_assets USING btree (viewable_id);


--
-- Name: index_assets_on_viewable_type_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_assets_on_viewable_type_and_type ON public.spree_assets USING btree (viewable_type, type);


--
-- Name: index_batch_collection_line_items_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_batch_collection_line_items_on_deleted_at ON public.batch_collection_line_items USING btree (deleted_at);


--
-- Name: index_batch_collections_on_batch_key; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_batch_collections_on_batch_key ON public.batch_collections USING btree (batch_key);


--
-- Name: index_celebrity_inspirations_on_spree_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_celebrity_inspirations_on_spree_product_id ON public.celebrity_inspirations USING btree (spree_product_id);


--
-- Name: index_curations_on_pid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_curations_on_pid ON public.curations USING btree (pid);


--
-- Name: index_curations_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_curations_on_product_id ON public.curations USING btree (product_id);


--
-- Name: index_curations_taxons_on_curation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_curations_taxons_on_curation_id ON public.curations_taxons USING btree (curation_id);


--
-- Name: index_customisation_values_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customisation_values_on_product_id ON public.customisation_values USING btree (product_id);


--
-- Name: index_customization_visualizations_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customization_visualizations_on_product_id ON public.customization_visualizations USING btree (product_id);


--
-- Name: index_discounts_on_discountable_and_sale_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_discounts_on_discountable_and_sale_id ON public.discounts USING btree (discountable_type, discountable_id, sale_id);


--
-- Name: index_discounts_on_discountable_id_and_discountable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_discounts_on_discountable_id_and_discountable_type ON public.discounts USING btree (discountable_id, discountable_type);


--
-- Name: index_discounts_on_sale_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_discounts_on_sale_id ON public.discounts USING btree (sale_id);


--
-- Name: index_email_notifications_on_spree_user_id_and_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_email_notifications_on_spree_user_id_and_code ON public.email_notifications USING btree (spree_user_id, code);


--
-- Name: index_fabric_card_colours_on_fabric_card_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fabric_card_colours_on_fabric_card_id ON public.fabric_card_colours USING btree (fabric_card_id);


--
-- Name: index_fabric_card_colours_on_fabric_colour_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fabric_card_colours_on_fabric_colour_id ON public.fabric_card_colours USING btree (fabric_colour_id);


--
-- Name: index_fabrication_events_on_fabrication_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fabrication_events_on_fabrication_uuid ON public.fabrication_events USING btree (fabrication_uuid);


--
-- Name: index_fabrications_on_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fabrications_on_line_item_id ON public.fabrications USING btree (line_item_id);


--
-- Name: index_fabrications_on_purchase_order_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fabrications_on_purchase_order_number ON public.fabrications USING btree (purchase_order_number);


--
-- Name: index_fabrications_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_fabrications_on_uuid ON public.fabrications USING btree (uuid);


--
-- Name: index_fabrics_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fabrics_on_name ON public.fabrics USING btree (name);


--
-- Name: index_fabrics_on_option_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_fabrics_on_option_value_id ON public.fabrics USING btree (option_value_id);


--
-- Name: index_facebook_data_on_spree_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_facebook_data_on_spree_user_id ON public.facebook_data USING btree (spree_user_id);


--
-- Name: index_global_skus_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_global_skus_on_product_id ON public.global_skus USING btree (product_id);


--
-- Name: index_global_skus_on_sku; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_global_skus_on_sku ON public.global_skus USING btree (sku);


--
-- Name: index_global_skus_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_global_skus_on_variant_id ON public.global_skus USING btree (variant_id);


--
-- Name: index_incompatibilities_on_incompatible_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incompatibilities_on_incompatible_id ON public.incompatibilities USING btree (incompatible_id);


--
-- Name: index_incompatibilities_on_original_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_incompatibilities_on_original_id ON public.incompatibilities USING btree (original_id);


--
-- Name: index_inspirations_on_spree_product_id_and_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inspirations_on_spree_product_id_and_active ON public.inspirations USING btree (spree_product_id, active);


--
-- Name: index_inventory_units_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_units_on_order_id ON public.spree_inventory_units USING btree (order_id);


--
-- Name: index_inventory_units_on_shipment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_units_on_shipment_id ON public.spree_inventory_units USING btree (shipment_id);


--
-- Name: index_inventory_units_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inventory_units_on_variant_id ON public.spree_inventory_units USING btree (variant_id);


--
-- Name: index_item_return_events_on_item_return_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_return_events_on_item_return_uuid ON public.item_return_events USING btree (item_return_uuid);


--
-- Name: index_item_returns_on_item_return_label_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_returns_on_item_return_label_id ON public.item_returns USING btree (item_return_label_id);


--
-- Name: index_item_returns_on_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_item_returns_on_line_item_id ON public.item_returns USING btree (line_item_id);


--
-- Name: index_item_returns_on_order_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_item_returns_on_order_number ON public.item_returns USING btree (order_number);


--
-- Name: index_item_returns_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_item_returns_on_uuid ON public.item_returns USING btree (uuid);


--
-- Name: index_line_item_making_options_on_line_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_making_options_on_line_item ON public.line_item_making_options USING btree (line_item_id);


--
-- Name: index_line_item_on_fabric_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_on_fabric_id ON public.spree_line_items USING btree (fabric_id);


--
-- Name: index_line_item_personalizations_on_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_personalizations_on_line_item_id ON public.line_item_personalizations USING btree (line_item_id);


--
-- Name: index_line_item_size_normalisations_on_line_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_size_normalisations_on_line_item_id ON public.line_item_size_normalisations USING btree (line_item_id);


--
-- Name: index_line_item_size_normalisations_on_new_size_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_size_normalisations_on_new_size_id ON public.line_item_size_normalisations USING btree (new_size_id);


--
-- Name: index_line_item_size_normalisations_on_new_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_size_normalisations_on_new_variant_id ON public.line_item_size_normalisations USING btree (new_variant_id);


--
-- Name: index_line_item_size_normalisations_on_old_size_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_size_normalisations_on_old_size_id ON public.line_item_size_normalisations USING btree (old_size_id);


--
-- Name: index_line_item_size_normalisations_on_old_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_size_normalisations_on_old_variant_id ON public.line_item_size_normalisations USING btree (old_variant_id);


--
-- Name: index_line_item_updates_on_bulk_order_update_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_line_item_updates_on_bulk_order_update_id ON public.line_item_updates USING btree (bulk_order_update_id);


--
-- Name: index_marketing_order_traffic_parameters_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_marketing_order_traffic_parameters_on_order_id ON public.marketing_order_traffic_parameters USING btree (order_id);


--
-- Name: index_marketing_user_visits_on_spree_user_id_and_utm_campaign; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_marketing_user_visits_on_spree_user_id_and_utm_campaign ON public.marketing_user_visits USING btree (spree_user_id, utm_campaign);


--
-- Name: index_marketing_user_visits_on_user_token_and_utm_campaign; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_marketing_user_visits_on_user_token_and_utm_campaign ON public.marketing_user_visits USING btree (user_token, utm_campaign);


--
-- Name: index_moodboard_collaborators_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_collaborators_on_email ON public.moodboard_collaborators USING btree (email);


--
-- Name: index_moodboard_collaborators_on_moodboard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_collaborators_on_moodboard_id ON public.moodboard_collaborators USING btree (moodboard_id);


--
-- Name: index_moodboard_collaborators_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_collaborators_on_user_id ON public.moodboard_collaborators USING btree (user_id);


--
-- Name: index_moodboard_comments_on_moodboard_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_comments_on_moodboard_item_id ON public.moodboard_item_comments USING btree (moodboard_item_id);


--
-- Name: index_moodboard_item_events_on_moodboard_item_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_item_events_on_moodboard_item_uuid ON public.moodboard_item_events USING btree (moodboard_item_uuid);


--
-- Name: index_moodboard_items_on_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_items_on_color_id ON public.moodboard_items USING btree (color_id);


--
-- Name: index_moodboard_items_on_moodboard_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_items_on_moodboard_id ON public.moodboard_items USING btree (moodboard_id);


--
-- Name: index_moodboard_items_on_product_color_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_items_on_product_color_value_id ON public.moodboard_items USING btree (product_color_value_id);


--
-- Name: index_moodboard_items_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_items_on_product_id ON public.moodboard_items USING btree (product_id);


--
-- Name: index_moodboard_items_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_items_on_user_id ON public.moodboard_items USING btree (user_id);


--
-- Name: index_moodboard_items_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_items_on_uuid ON public.moodboard_items USING btree (uuid);


--
-- Name: index_moodboard_items_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboard_items_on_variant_id ON public.moodboard_items USING btree (variant_id);


--
-- Name: index_moodboards_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_moodboards_on_user_id ON public.moodboards USING btree (user_id);


--
-- Name: index_option_values_variants_on_variant_id_and_option_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_option_values_variants_on_variant_id_and_option_value_id ON public.spree_option_values_variants USING btree (variant_id, option_value_id);


--
-- Name: index_payment_requests_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_requests_on_order_id ON public.payment_requests USING btree (order_id);


--
-- Name: index_payment_requests_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payment_requests_on_token ON public.payment_requests USING btree (token);


--
-- Name: index_product_accessories_on_spree_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_accessories_on_spree_product_id ON public.product_accessories USING btree (spree_product_id);


--
-- Name: index_product_accessories_on_style_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_accessories_on_style_id ON public.product_accessories USING btree (style_id);


--
-- Name: index_product_color_values_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_color_values_on_product_id ON public.product_color_values USING btree (product_id);


--
-- Name: index_product_making_options_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_making_options_on_product_id ON public.product_making_options USING btree (product_id, active, old_option_type);


--
-- Name: index_product_properties_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_properties_on_product_id ON public.spree_product_properties USING btree (product_id);


--
-- Name: index_product_reservations_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_reservations_on_user_id ON public.product_reservations USING btree (user_id);


--
-- Name: index_product_style_profiles_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_style_profiles_on_product_id ON public.product_style_profiles USING btree (product_id);


--
-- Name: index_products_promotion_rules_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_promotion_rules_on_product_id ON public.spree_products_promotion_rules USING btree (product_id);


--
-- Name: index_products_promotion_rules_on_promotion_rule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_promotion_rules_on_promotion_rule_id ON public.spree_products_promotion_rules USING btree (promotion_rule_id);


--
-- Name: index_promotion_rules_on_product_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_promotion_rules_on_product_group_id ON public.spree_promotion_rules USING btree (product_group_id);


--
-- Name: index_promotion_rules_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_promotion_rules_on_user_id ON public.spree_promotion_rules USING btree (user_id);


--
-- Name: index_promotion_rules_users_on_promotion_rule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_promotion_rules_users_on_promotion_rule_id ON public.spree_promotion_rules_users USING btree (promotion_rule_id);


--
-- Name: index_promotion_rules_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_promotion_rules_users_on_user_id ON public.spree_promotion_rules_users USING btree (user_id);


--
-- Name: index_questions_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_position ON public.questions USING btree ("position");


--
-- Name: index_questions_on_quiz_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_questions_on_quiz_id ON public.questions USING btree (quiz_id);


--
-- Name: index_return_inventory_items_on_active_and_available; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_return_inventory_items_on_active_and_available ON public.return_inventory_items USING btree (active, available);


--
-- Name: index_return_inventory_items_on_style_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_return_inventory_items_on_style_number ON public.return_inventory_items USING btree (style_number);


--
-- Name: index_return_inventory_items_on_upc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_return_inventory_items_on_upc ON public.return_inventory_items USING btree (upc);


--
-- Name: index_revolution_pages_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revolution_pages_on_parent_id ON public.revolution_pages USING btree (parent_id);


--
-- Name: index_revolution_pages_on_path; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_revolution_pages_on_path ON public.revolution_pages USING btree (path);


--
-- Name: index_revolution_pages_on_publish_from_and_publish_to; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revolution_pages_on_publish_from_and_publish_to ON public.revolution_pages USING btree (publish_from, publish_to);


--
-- Name: index_revolution_pages_on_rgt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revolution_pages_on_rgt ON public.revolution_pages USING btree (rgt);


--
-- Name: index_revolution_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revolution_translations_on_locale ON public.revolution_translations USING btree (locale);


--
-- Name: index_revolution_translations_on_page_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_revolution_translations_on_page_id ON public.revolution_translations USING btree (page_id);


--
-- Name: index_shipments_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_shipments_on_number ON public.spree_shipments USING btree (number);


--
-- Name: index_similarities_on_original_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_similarities_on_original_id ON public.similarities USING btree (original_id);


--
-- Name: index_similarities_on_similar_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_similarities_on_similar_id ON public.similarities USING btree (similar_id);


--
-- Name: index_simple_key_values_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_simple_key_values_on_key ON public.simple_key_values USING btree (key);


--
-- Name: index_site_versions_on_zone_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_site_versions_on_zone_id ON public.site_versions USING btree (zone_id);


--
-- Name: index_spree_configurations_on_name_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_configurations_on_name_and_type ON public.spree_configurations USING btree (name, type);


--
-- Name: index_spree_line_items_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_line_items_on_order_id ON public.spree_line_items USING btree (order_id);


--
-- Name: index_spree_line_items_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_line_items_on_variant_id ON public.spree_line_items USING btree (variant_id);


--
-- Name: index_spree_option_values_groups_on_option_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_option_values_groups_on_option_type_id ON public.spree_option_values_groups USING btree (option_type_id);


--
-- Name: index_spree_option_values_on_option_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_option_values_on_option_type_id ON public.spree_option_values USING btree (option_type_id);


--
-- Name: index_spree_option_values_on_presentation; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_option_values_on_presentation ON public.spree_option_values USING btree (presentation);


--
-- Name: index_spree_option_values_variants_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_option_values_variants_on_variant_id ON public.spree_option_values_variants USING btree (variant_id);


--
-- Name: index_spree_orders_on_completed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_orders_on_completed_at ON public.spree_orders USING btree (completed_at);


--
-- Name: index_spree_orders_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_orders_on_created_at ON public.spree_orders USING btree (created_at);


--
-- Name: index_spree_orders_on_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_orders_on_number ON public.spree_orders USING btree (number);


--
-- Name: index_spree_orders_on_shipment_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_orders_on_shipment_state ON public.spree_orders USING btree (shipment_state);


--
-- Name: index_spree_orders_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_orders_on_state ON public.spree_orders USING btree (state);


--
-- Name: index_spree_orders_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_orders_on_user_id ON public.spree_orders USING btree (user_id);


--
-- Name: index_spree_payments_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_payments_on_order_id ON public.spree_payments USING btree (order_id);


--
-- Name: index_spree_paypal_express_checkouts_on_transaction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_paypal_express_checkouts_on_transaction_id ON public.spree_paypal_express_checkouts USING btree (transaction_id);


--
-- Name: index_spree_preferences_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_spree_preferences_on_key ON public.spree_preferences USING btree (key);


--
-- Name: index_spree_prices_on_variant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_prices_on_variant_id ON public.spree_prices USING btree (variant_id);


--
-- Name: index_spree_product_option_types_on_option_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_product_option_types_on_option_type_id ON public.spree_product_option_types USING btree (option_type_id);


--
-- Name: index_spree_product_option_types_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_product_option_types_on_product_id ON public.spree_product_option_types USING btree (product_id);


--
-- Name: index_spree_product_related_outerwear_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_product_related_outerwear_on_product_id ON public.spree_product_related_outerwear USING btree (product_id);


--
-- Name: index_spree_products_on_available_on; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_products_on_available_on ON public.spree_products USING btree (available_on);


--
-- Name: index_spree_products_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_products_on_deleted_at ON public.spree_products USING btree (deleted_at);


--
-- Name: index_spree_products_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_products_on_name ON public.spree_products USING btree (name);


--
-- Name: index_spree_products_on_permalink; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_products_on_permalink ON public.spree_products USING btree (permalink);


--
-- Name: index_spree_products_taxons_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_products_taxons_on_product_id ON public.spree_products_taxons USING btree (product_id);


--
-- Name: index_spree_products_taxons_on_taxon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_products_taxons_on_taxon_id ON public.spree_products_taxons USING btree (taxon_id);


--
-- Name: index_spree_roles_users_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_roles_users_on_role_id ON public.spree_roles_users USING btree (role_id);


--
-- Name: index_spree_roles_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_roles_users_on_user_id ON public.spree_roles_users USING btree (user_id);


--
-- Name: index_spree_shipments_on_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_shipments_on_order_id ON public.spree_shipments USING btree (order_id);


--
-- Name: index_spree_taxon_banners_on_spree_taxon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_taxon_banners_on_spree_taxon_id ON public.spree_taxon_banners USING btree (spree_taxon_id);


--
-- Name: index_spree_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_users_on_authentication_token ON public.spree_users USING btree (authentication_token);


--
-- Name: index_spree_variants_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_variants_on_product_id ON public.spree_variants USING btree (product_id);


--
-- Name: index_spree_variants_on_sku; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spree_variants_on_sku ON public.spree_variants USING btree (sku);


--
-- Name: index_style_reports_on_spree_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_style_reports_on_spree_user_id ON public.user_style_profiles USING btree (user_id);


--
-- Name: index_taxons_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taxons_on_parent_id ON public.spree_taxons USING btree (parent_id);


--
-- Name: index_taxons_on_permalink; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taxons_on_permalink ON public.spree_taxons USING btree (permalink);


--
-- Name: index_taxons_on_taxonomy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_taxons_on_taxonomy_id ON public.spree_taxons USING btree (taxonomy_id);


--
-- Name: index_tokenized_name_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tokenized_name_and_type ON public.spree_tokenized_permissions USING btree (permissable_id, permissable_type);


--
-- Name: index_wedding_atelier_likes_on_user_id_and_event_dress_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_wedding_atelier_likes_on_user_id_and_event_dress_id ON public.wedding_atelier_likes USING btree (user_id, event_dress_id);


--
-- Name: index_wishlist_items_on_spree_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wishlist_items_on_spree_product_id ON public.wishlist_items USING btree (spree_product_id);


--
-- Name: index_wishlist_items_on_spree_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_wishlist_items_on_spree_user_id ON public.wishlist_items USING btree (spree_user_id);


--
-- Name: ix_fabrics_on_fabric_color_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX ix_fabrics_on_fabric_color_id ON public.fabrics USING btree (option_value_id);


--
-- Name: opovg_option_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX opovg_option_group_id ON public.option_values_option_values_groups USING btree (option_values_group_id);


--
-- Name: opovg_option_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX opovg_option_value_id ON public.option_values_option_values_groups USING btree (option_value_id);


--
-- Name: permalink_idx_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX permalink_idx_unique ON public.spree_products USING btree (permalink);


--
-- Name: spree_product_related_outerwear_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX spree_product_related_outerwear_unique_index ON public.spree_product_related_outerwear USING btree (outerwear_id, product_id);


--
-- Name: unique_data_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_data_migrations ON public.data_migrations USING btree (version);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON public.schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20130506004537');

INSERT INTO schema_migrations (version) VALUES ('20130506004538');

INSERT INTO schema_migrations (version) VALUES ('20130506004539');

INSERT INTO schema_migrations (version) VALUES ('20130506004540');

INSERT INTO schema_migrations (version) VALUES ('20130506004541');

INSERT INTO schema_migrations (version) VALUES ('20130506004542');

INSERT INTO schema_migrations (version) VALUES ('20130506004543');

INSERT INTO schema_migrations (version) VALUES ('20130506004544');

INSERT INTO schema_migrations (version) VALUES ('20130506004545');

INSERT INTO schema_migrations (version) VALUES ('20130506004546');

INSERT INTO schema_migrations (version) VALUES ('20130506004547');

INSERT INTO schema_migrations (version) VALUES ('20130506004548');

INSERT INTO schema_migrations (version) VALUES ('20130506004549');

INSERT INTO schema_migrations (version) VALUES ('20130506004550');

INSERT INTO schema_migrations (version) VALUES ('20130506004551');

INSERT INTO schema_migrations (version) VALUES ('20130506004552');

INSERT INTO schema_migrations (version) VALUES ('20130506004553');

INSERT INTO schema_migrations (version) VALUES ('20130506004554');

INSERT INTO schema_migrations (version) VALUES ('20130506004555');

INSERT INTO schema_migrations (version) VALUES ('20130506004556');

INSERT INTO schema_migrations (version) VALUES ('20130506004557');

INSERT INTO schema_migrations (version) VALUES ('20130506004558');

INSERT INTO schema_migrations (version) VALUES ('20130506004559');

INSERT INTO schema_migrations (version) VALUES ('20130506004560');

INSERT INTO schema_migrations (version) VALUES ('20130506004561');

INSERT INTO schema_migrations (version) VALUES ('20130506004562');

INSERT INTO schema_migrations (version) VALUES ('20130506004563');

INSERT INTO schema_migrations (version) VALUES ('20130506004564');

INSERT INTO schema_migrations (version) VALUES ('20130506004565');

INSERT INTO schema_migrations (version) VALUES ('20130506004566');

INSERT INTO schema_migrations (version) VALUES ('20130506004567');

INSERT INTO schema_migrations (version) VALUES ('20130506004568');

INSERT INTO schema_migrations (version) VALUES ('20130506010338');

INSERT INTO schema_migrations (version) VALUES ('20130506010339');

INSERT INTO schema_migrations (version) VALUES ('20130506010340');

INSERT INTO schema_migrations (version) VALUES ('20130506010341');

INSERT INTO schema_migrations (version) VALUES ('20130506010342');

INSERT INTO schema_migrations (version) VALUES ('20130506010343');

INSERT INTO schema_migrations (version) VALUES ('20130506010344');

INSERT INTO schema_migrations (version) VALUES ('20130506010345');

INSERT INTO schema_migrations (version) VALUES ('20130512205026');

INSERT INTO schema_migrations (version) VALUES ('20130512205027');

INSERT INTO schema_migrations (version) VALUES ('20130514133828');

INSERT INTO schema_migrations (version) VALUES ('20130515080346');

INSERT INTO schema_migrations (version) VALUES ('20130516043841');

INSERT INTO schema_migrations (version) VALUES ('20130517210021');

INSERT INTO schema_migrations (version) VALUES ('20130517210339');

INSERT INTO schema_migrations (version) VALUES ('20130518123711');

INSERT INTO schema_migrations (version) VALUES ('20130518123741');

INSERT INTO schema_migrations (version) VALUES ('20130518123810');

INSERT INTO schema_migrations (version) VALUES ('20130518124159');

INSERT INTO schema_migrations (version) VALUES ('20130519071226');

INSERT INTO schema_migrations (version) VALUES ('20130519113451');

INSERT INTO schema_migrations (version) VALUES ('20130520032831');

INSERT INTO schema_migrations (version) VALUES ('20130520032858');

INSERT INTO schema_migrations (version) VALUES ('20130520032930');

INSERT INTO schema_migrations (version) VALUES ('20130521142607');

INSERT INTO schema_migrations (version) VALUES ('20130521150852');

INSERT INTO schema_migrations (version) VALUES ('20130524094117');

INSERT INTO schema_migrations (version) VALUES ('20130524094822');

INSERT INTO schema_migrations (version) VALUES ('20130524095008');

INSERT INTO schema_migrations (version) VALUES ('20130524095411');

INSERT INTO schema_migrations (version) VALUES ('20130524095429');

INSERT INTO schema_migrations (version) VALUES ('20130524095805');

INSERT INTO schema_migrations (version) VALUES ('20130528093803');

INSERT INTO schema_migrations (version) VALUES ('20130602214050');

INSERT INTO schema_migrations (version) VALUES ('20130602214103');

INSERT INTO schema_migrations (version) VALUES ('20130603082632');

INSERT INTO schema_migrations (version) VALUES ('20130604000544');

INSERT INTO schema_migrations (version) VALUES ('20130605004330');

INSERT INTO schema_migrations (version) VALUES ('20130605115058');

INSERT INTO schema_migrations (version) VALUES ('20130605115201');

INSERT INTO schema_migrations (version) VALUES ('20130605115336');

INSERT INTO schema_migrations (version) VALUES ('20130605122344');

INSERT INTO schema_migrations (version) VALUES ('20130606201618');

INSERT INTO schema_migrations (version) VALUES ('20130606214352');

INSERT INTO schema_migrations (version) VALUES ('20130610195813');

INSERT INTO schema_migrations (version) VALUES ('20130610212606');

INSERT INTO schema_migrations (version) VALUES ('20130611102425');

INSERT INTO schema_migrations (version) VALUES ('20130611111711');

INSERT INTO schema_migrations (version) VALUES ('20130611131704');

INSERT INTO schema_migrations (version) VALUES ('20130613084212');

INSERT INTO schema_migrations (version) VALUES ('20130613084304');

INSERT INTO schema_migrations (version) VALUES ('20130613091438');

INSERT INTO schema_migrations (version) VALUES ('20130619145546');

INSERT INTO schema_migrations (version) VALUES ('20130620113821');

INSERT INTO schema_migrations (version) VALUES ('20130620120830');

INSERT INTO schema_migrations (version) VALUES ('20130620121157');

INSERT INTO schema_migrations (version) VALUES ('20130620121636');

INSERT INTO schema_migrations (version) VALUES ('20130620121853');

INSERT INTO schema_migrations (version) VALUES ('20130620121958');

INSERT INTO schema_migrations (version) VALUES ('20130620132002');

INSERT INTO schema_migrations (version) VALUES ('20130621062928');

INSERT INTO schema_migrations (version) VALUES ('20130621071835');

INSERT INTO schema_migrations (version) VALUES ('20130621074200');

INSERT INTO schema_migrations (version) VALUES ('20130621080804');

INSERT INTO schema_migrations (version) VALUES ('20130621090612');

INSERT INTO schema_migrations (version) VALUES ('20130621091745');

INSERT INTO schema_migrations (version) VALUES ('20130621093450');

INSERT INTO schema_migrations (version) VALUES ('20130621103852');

INSERT INTO schema_migrations (version) VALUES ('20130621111737');

INSERT INTO schema_migrations (version) VALUES ('20130621111930');

INSERT INTO schema_migrations (version) VALUES ('20130621115531');

INSERT INTO schema_migrations (version) VALUES ('20130621115706');

INSERT INTO schema_migrations (version) VALUES ('20130621115805');

INSERT INTO schema_migrations (version) VALUES ('20130621115841');

INSERT INTO schema_migrations (version) VALUES ('20130621115924');

INSERT INTO schema_migrations (version) VALUES ('20130621120011');

INSERT INTO schema_migrations (version) VALUES ('20130621120752');

INSERT INTO schema_migrations (version) VALUES ('20130621144047');

INSERT INTO schema_migrations (version) VALUES ('20130624065452');

INSERT INTO schema_migrations (version) VALUES ('20130624071717');

INSERT INTO schema_migrations (version) VALUES ('20130624072135');

INSERT INTO schema_migrations (version) VALUES ('20130624124337');

INSERT INTO schema_migrations (version) VALUES ('20130625063347');

INSERT INTO schema_migrations (version) VALUES ('20130625102200');

INSERT INTO schema_migrations (version) VALUES ('20130625102926');

INSERT INTO schema_migrations (version) VALUES ('20130625103545');

INSERT INTO schema_migrations (version) VALUES ('20130625104716');

INSERT INTO schema_migrations (version) VALUES ('20130626045146');

INSERT INTO schema_migrations (version) VALUES ('20130701043431');

INSERT INTO schema_migrations (version) VALUES ('20130701043900');

INSERT INTO schema_migrations (version) VALUES ('20130701072015');

INSERT INTO schema_migrations (version) VALUES ('20130701113447');

INSERT INTO schema_migrations (version) VALUES ('20130704203545');

INSERT INTO schema_migrations (version) VALUES ('20130706135307');

INSERT INTO schema_migrations (version) VALUES ('20130706152228');

INSERT INTO schema_migrations (version) VALUES ('20130707181457');

INSERT INTO schema_migrations (version) VALUES ('20130714204511');

INSERT INTO schema_migrations (version) VALUES ('20130717115634');

INSERT INTO schema_migrations (version) VALUES ('20130717211445');

INSERT INTO schema_migrations (version) VALUES ('20130718102539');

INSERT INTO schema_migrations (version) VALUES ('20130722033333');

INSERT INTO schema_migrations (version) VALUES ('20130722211519');

INSERT INTO schema_migrations (version) VALUES ('20130722211520');

INSERT INTO schema_migrations (version) VALUES ('20130722211521');

INSERT INTO schema_migrations (version) VALUES ('20130722211522');

INSERT INTO schema_migrations (version) VALUES ('20130722211523');

INSERT INTO schema_migrations (version) VALUES ('20130722211524');

INSERT INTO schema_migrations (version) VALUES ('20130722211525');

INSERT INTO schema_migrations (version) VALUES ('20130722211526');

INSERT INTO schema_migrations (version) VALUES ('20130722211527');

INSERT INTO schema_migrations (version) VALUES ('20130722211528');

INSERT INTO schema_migrations (version) VALUES ('20130722211529');

INSERT INTO schema_migrations (version) VALUES ('20130722211530');

INSERT INTO schema_migrations (version) VALUES ('20130722211531');

INSERT INTO schema_migrations (version) VALUES ('20130722211532');

INSERT INTO schema_migrations (version) VALUES ('20130722211533');

INSERT INTO schema_migrations (version) VALUES ('20130723181942');

INSERT INTO schema_migrations (version) VALUES ('20130726142043');

INSERT INTO schema_migrations (version) VALUES ('20130728141856');

INSERT INTO schema_migrations (version) VALUES ('20130728152030');

INSERT INTO schema_migrations (version) VALUES ('20130730203853');

INSERT INTO schema_migrations (version) VALUES ('20130805001156');

INSERT INTO schema_migrations (version) VALUES ('20130806102939');

INSERT INTO schema_migrations (version) VALUES ('20130807012751');

INSERT INTO schema_migrations (version) VALUES ('20130819173717');

INSERT INTO schema_migrations (version) VALUES ('20130829230100');

INSERT INTO schema_migrations (version) VALUES ('20130829230101');

INSERT INTO schema_migrations (version) VALUES ('20130829230102');

INSERT INTO schema_migrations (version) VALUES ('20130829230103');

INSERT INTO schema_migrations (version) VALUES ('20130901104329');

INSERT INTO schema_migrations (version) VALUES ('20130908203444');

INSERT INTO schema_migrations (version) VALUES ('20130909174511');

INSERT INTO schema_migrations (version) VALUES ('20130911102117');

INSERT INTO schema_migrations (version) VALUES ('20130911165554');

INSERT INTO schema_migrations (version) VALUES ('20130912112336');

INSERT INTO schema_migrations (version) VALUES ('20130913091108');

INSERT INTO schema_migrations (version) VALUES ('20130913122839');

INSERT INTO schema_migrations (version) VALUES ('20130914045748');

INSERT INTO schema_migrations (version) VALUES ('20130916125148');

INSERT INTO schema_migrations (version) VALUES ('20130920095136');

INSERT INTO schema_migrations (version) VALUES ('20130921154943');

INSERT INTO schema_migrations (version) VALUES ('20130921164035');

INSERT INTO schema_migrations (version) VALUES ('20130921164415');

INSERT INTO schema_migrations (version) VALUES ('20130922044140');

INSERT INTO schema_migrations (version) VALUES ('20130922064021');

INSERT INTO schema_migrations (version) VALUES ('20130922120803');

INSERT INTO schema_migrations (version) VALUES ('20130926115334');

INSERT INTO schema_migrations (version) VALUES ('20130926152904');

INSERT INTO schema_migrations (version) VALUES ('20131009085515');

INSERT INTO schema_migrations (version) VALUES ('20131010055500');

INSERT INTO schema_migrations (version) VALUES ('20131010103630');

INSERT INTO schema_migrations (version) VALUES ('20131011142152');

INSERT INTO schema_migrations (version) VALUES ('20131016124317');

INSERT INTO schema_migrations (version) VALUES ('20131016124824');

INSERT INTO schema_migrations (version) VALUES ('20131016125436');

INSERT INTO schema_migrations (version) VALUES ('20131016150103');

INSERT INTO schema_migrations (version) VALUES ('20131030065203');

INSERT INTO schema_migrations (version) VALUES ('20131030065248');

INSERT INTO schema_migrations (version) VALUES ('20131030065323');

INSERT INTO schema_migrations (version) VALUES ('20131030070401');

INSERT INTO schema_migrations (version) VALUES ('20131031150103');

INSERT INTO schema_migrations (version) VALUES ('20131031184353');

INSERT INTO schema_migrations (version) VALUES ('20131108204233');

INSERT INTO schema_migrations (version) VALUES ('20131116114518');

INSERT INTO schema_migrations (version) VALUES ('20131121102042');

INSERT INTO schema_migrations (version) VALUES ('20131121102403');

INSERT INTO schema_migrations (version) VALUES ('20131121124753');

INSERT INTO schema_migrations (version) VALUES ('20131203114020');

INSERT INTO schema_migrations (version) VALUES ('20131204161903');

INSERT INTO schema_migrations (version) VALUES ('20131210193138');

INSERT INTO schema_migrations (version) VALUES ('20131218071822');

INSERT INTO schema_migrations (version) VALUES ('20140129091937');

INSERT INTO schema_migrations (version) VALUES ('20140131145806');

INSERT INTO schema_migrations (version) VALUES ('20140203152220');

INSERT INTO schema_migrations (version) VALUES ('20140205193055');

INSERT INTO schema_migrations (version) VALUES ('20140210090904');

INSERT INTO schema_migrations (version) VALUES ('20140212110458');

INSERT INTO schema_migrations (version) VALUES ('20140213103543');

INSERT INTO schema_migrations (version) VALUES ('20140213194554');

INSERT INTO schema_migrations (version) VALUES ('20140213205349');

INSERT INTO schema_migrations (version) VALUES ('20140214124223');

INSERT INTO schema_migrations (version) VALUES ('20140214191531');

INSERT INTO schema_migrations (version) VALUES ('20140215213352');

INSERT INTO schema_migrations (version) VALUES ('20140216133229');

INSERT INTO schema_migrations (version) VALUES ('20140224112248');

INSERT INTO schema_migrations (version) VALUES ('20140224150729');

INSERT INTO schema_migrations (version) VALUES ('20140224210602');

INSERT INTO schema_migrations (version) VALUES ('20140227101550');

INSERT INTO schema_migrations (version) VALUES ('20140304200608');

INSERT INTO schema_migrations (version) VALUES ('20140306150008');

INSERT INTO schema_migrations (version) VALUES ('20140311133004');

INSERT INTO schema_migrations (version) VALUES ('20140312112600');

INSERT INTO schema_migrations (version) VALUES ('20140312123919');

INSERT INTO schema_migrations (version) VALUES ('20140313131540');

INSERT INTO schema_migrations (version) VALUES ('20140314060126');

INSERT INTO schema_migrations (version) VALUES ('20140314080553');

INSERT INTO schema_migrations (version) VALUES ('20140314080937');

INSERT INTO schema_migrations (version) VALUES ('20140314081132');

INSERT INTO schema_migrations (version) VALUES ('20140314083146');

INSERT INTO schema_migrations (version) VALUES ('20140314102016');

INSERT INTO schema_migrations (version) VALUES ('20140409141631');

INSERT INTO schema_migrations (version) VALUES ('20140409141803');

INSERT INTO schema_migrations (version) VALUES ('20140417113058');

INSERT INTO schema_migrations (version) VALUES ('20140429140316');

INSERT INTO schema_migrations (version) VALUES ('20140507161951');

INSERT INTO schema_migrations (version) VALUES ('20140528062855');

INSERT INTO schema_migrations (version) VALUES ('20140603043237');

INSERT INTO schema_migrations (version) VALUES ('20140828002342');

INSERT INTO schema_migrations (version) VALUES ('20140901052850');

INSERT INTO schema_migrations (version) VALUES ('20140901052851');

INSERT INTO schema_migrations (version) VALUES ('20140901062407');

INSERT INTO schema_migrations (version) VALUES ('20140904044019');

INSERT INTO schema_migrations (version) VALUES ('20140904044908');

INSERT INTO schema_migrations (version) VALUES ('20140915230844');

INSERT INTO schema_migrations (version) VALUES ('20140925181257');

INSERT INTO schema_migrations (version) VALUES ('20141013211312');

INSERT INTO schema_migrations (version) VALUES ('20141019025652');

INSERT INTO schema_migrations (version) VALUES ('20141019103649');

INSERT INTO schema_migrations (version) VALUES ('20141030224601');

INSERT INTO schema_migrations (version) VALUES ('20141104194804');

INSERT INTO schema_migrations (version) VALUES ('20141114172825');

INSERT INTO schema_migrations (version) VALUES ('20141119083016');

INSERT INTO schema_migrations (version) VALUES ('20141119084010');

INSERT INTO schema_migrations (version) VALUES ('20141121095244');

INSERT INTO schema_migrations (version) VALUES ('20141121153610');

INSERT INTO schema_migrations (version) VALUES ('20141127203110');

INSERT INTO schema_migrations (version) VALUES ('20141130212315');

INSERT INTO schema_migrations (version) VALUES ('20141130212501');

INSERT INTO schema_migrations (version) VALUES ('20141202112234');

INSERT INTO schema_migrations (version) VALUES ('20141202120254');

INSERT INTO schema_migrations (version) VALUES ('20141204221759');

INSERT INTO schema_migrations (version) VALUES ('20141222134710');

INSERT INTO schema_migrations (version) VALUES ('20141223102532');

INSERT INTO schema_migrations (version) VALUES ('20141223103221');

INSERT INTO schema_migrations (version) VALUES ('20150130132838');

INSERT INTO schema_migrations (version) VALUES ('20150201140321');

INSERT INTO schema_migrations (version) VALUES ('20150223154334');

INSERT INTO schema_migrations (version) VALUES ('20150309104816');

INSERT INTO schema_migrations (version) VALUES ('20150322224241');

INSERT INTO schema_migrations (version) VALUES ('20150409125133');

INSERT INTO schema_migrations (version) VALUES ('20150410004828');

INSERT INTO schema_migrations (version) VALUES ('20150410044711');

INSERT INTO schema_migrations (version) VALUES ('20150410080424');

INSERT INTO schema_migrations (version) VALUES ('20150413090108');

INSERT INTO schema_migrations (version) VALUES ('20150413090131');

INSERT INTO schema_migrations (version) VALUES ('20150421234323');

INSERT INTO schema_migrations (version) VALUES ('20150427031122');

INSERT INTO schema_migrations (version) VALUES ('20150506071406');

INSERT INTO schema_migrations (version) VALUES ('20150506075510');

INSERT INTO schema_migrations (version) VALUES ('20150507051538');

INSERT INTO schema_migrations (version) VALUES ('20150507113549');

INSERT INTO schema_migrations (version) VALUES ('20150508044557');

INSERT INTO schema_migrations (version) VALUES ('20150512022456');

INSERT INTO schema_migrations (version) VALUES ('20150512022516');

INSERT INTO schema_migrations (version) VALUES ('20150513043101');

INSERT INTO schema_migrations (version) VALUES ('20150515024100');

INSERT INTO schema_migrations (version) VALUES ('20150518001539');

INSERT INTO schema_migrations (version) VALUES ('20150518063901');

INSERT INTO schema_migrations (version) VALUES ('20150519111622');

INSERT INTO schema_migrations (version) VALUES ('20150527070209');

INSERT INTO schema_migrations (version) VALUES ('20150527074015');

INSERT INTO schema_migrations (version) VALUES ('20150529022139');

INSERT INTO schema_migrations (version) VALUES ('20150531191846');

INSERT INTO schema_migrations (version) VALUES ('20150603000010');

INSERT INTO schema_migrations (version) VALUES ('20150603000020');

INSERT INTO schema_migrations (version) VALUES ('20150603000030');

INSERT INTO schema_migrations (version) VALUES ('20150611024152');

INSERT INTO schema_migrations (version) VALUES ('20150622191313');

INSERT INTO schema_migrations (version) VALUES ('20150626012245');

INSERT INTO schema_migrations (version) VALUES ('20150713160857');

INSERT INTO schema_migrations (version) VALUES ('20150714102137');

INSERT INTO schema_migrations (version) VALUES ('20150715042756');

INSERT INTO schema_migrations (version) VALUES ('20150715081713');

INSERT INTO schema_migrations (version) VALUES ('20150721041443');

INSERT INTO schema_migrations (version) VALUES ('20150721165539');

INSERT INTO schema_migrations (version) VALUES ('20150724193721');

INSERT INTO schema_migrations (version) VALUES ('20150811143830');

INSERT INTO schema_migrations (version) VALUES ('20150812004018');

INSERT INTO schema_migrations (version) VALUES ('20150820211643');

INSERT INTO schema_migrations (version) VALUES ('20150822135103');

INSERT INTO schema_migrations (version) VALUES ('20150825014510');

INSERT INTO schema_migrations (version) VALUES ('20150826030111');

INSERT INTO schema_migrations (version) VALUES ('20150826171400');

INSERT INTO schema_migrations (version) VALUES ('20150828125426');

INSERT INTO schema_migrations (version) VALUES ('20150830020806');

INSERT INTO schema_migrations (version) VALUES ('20150830020807');

INSERT INTO schema_migrations (version) VALUES ('20150831032100');

INSERT INTO schema_migrations (version) VALUES ('20150831034422');

INSERT INTO schema_migrations (version) VALUES ('20150901051513');

INSERT INTO schema_migrations (version) VALUES ('20150902182659');

INSERT INTO schema_migrations (version) VALUES ('20150907000010');

INSERT INTO schema_migrations (version) VALUES ('20150907000020');

INSERT INTO schema_migrations (version) VALUES ('20150908042639');

INSERT INTO schema_migrations (version) VALUES ('20150908165717');

INSERT INTO schema_migrations (version) VALUES ('20150916071812');

INSERT INTO schema_migrations (version) VALUES ('20150921073046');

INSERT INTO schema_migrations (version) VALUES ('20150922152045');

INSERT INTO schema_migrations (version) VALUES ('20150923123642');

INSERT INTO schema_migrations (version) VALUES ('20150923132716');

INSERT INTO schema_migrations (version) VALUES ('20150924000000');

INSERT INTO schema_migrations (version) VALUES ('20150929060822');

INSERT INTO schema_migrations (version) VALUES ('20150930012703');

INSERT INTO schema_migrations (version) VALUES ('20151006052307');

INSERT INTO schema_migrations (version) VALUES ('20151006210716');

INSERT INTO schema_migrations (version) VALUES ('20151009061040');

INSERT INTO schema_migrations (version) VALUES ('20151011225607');

INSERT INTO schema_migrations (version) VALUES ('20151013020610');

INSERT INTO schema_migrations (version) VALUES ('20151016053138');

INSERT INTO schema_migrations (version) VALUES ('20151019034832');

INSERT INTO schema_migrations (version) VALUES ('20151021014658');

INSERT INTO schema_migrations (version) VALUES ('20151026025807');

INSERT INTO schema_migrations (version) VALUES ('20151026065720');

INSERT INTO schema_migrations (version) VALUES ('20151027024828');

INSERT INTO schema_migrations (version) VALUES ('20151027031855');

INSERT INTO schema_migrations (version) VALUES ('20151029003230');

INSERT INTO schema_migrations (version) VALUES ('20151110060532');

INSERT INTO schema_migrations (version) VALUES ('20151110165722');

INSERT INTO schema_migrations (version) VALUES ('20151111024907');

INSERT INTO schema_migrations (version) VALUES ('20151115223341');

INSERT INTO schema_migrations (version) VALUES ('20151115233021');

INSERT INTO schema_migrations (version) VALUES ('20151116233625');

INSERT INTO schema_migrations (version) VALUES ('20151116234839');

INSERT INTO schema_migrations (version) VALUES ('20151116235603');

INSERT INTO schema_migrations (version) VALUES ('20151117004020');

INSERT INTO schema_migrations (version) VALUES ('20151117011356');

INSERT INTO schema_migrations (version) VALUES ('20151117222516');

INSERT INTO schema_migrations (version) VALUES ('20151120060927');

INSERT INTO schema_migrations (version) VALUES ('20151124021319');

INSERT INTO schema_migrations (version) VALUES ('20151124233139');

INSERT INTO schema_migrations (version) VALUES ('20151126031957');

INSERT INTO schema_migrations (version) VALUES ('20151126055038');

INSERT INTO schema_migrations (version) VALUES ('20151126212504');

INSERT INTO schema_migrations (version) VALUES ('20151127025348');

INSERT INTO schema_migrations (version) VALUES ('20151130024414');

INSERT INTO schema_migrations (version) VALUES ('20151130082753');

INSERT INTO schema_migrations (version) VALUES ('20151201070911');

INSERT INTO schema_migrations (version) VALUES ('20151202072538');

INSERT INTO schema_migrations (version) VALUES ('20151202125406');

INSERT INTO schema_migrations (version) VALUES ('20151202221751');

INSERT INTO schema_migrations (version) VALUES ('20151204072651');

INSERT INTO schema_migrations (version) VALUES ('20151207063523');

INSERT INTO schema_migrations (version) VALUES ('20151209025300');

INSERT INTO schema_migrations (version) VALUES ('20151209035232');

INSERT INTO schema_migrations (version) VALUES ('20151210015926');

INSERT INTO schema_migrations (version) VALUES ('20151210043530');

INSERT INTO schema_migrations (version) VALUES ('20151210055035');

INSERT INTO schema_migrations (version) VALUES ('20151210230429');

INSERT INTO schema_migrations (version) VALUES ('20151224020910');

INSERT INTO schema_migrations (version) VALUES ('20160105035758');

INSERT INTO schema_migrations (version) VALUES ('20160107044610');

INSERT INTO schema_migrations (version) VALUES ('20160110231930');

INSERT INTO schema_migrations (version) VALUES ('20160111213754');

INSERT INTO schema_migrations (version) VALUES ('20160201051315');

INSERT INTO schema_migrations (version) VALUES ('20160201055756');

INSERT INTO schema_migrations (version) VALUES ('20160202192721');

INSERT INTO schema_migrations (version) VALUES ('20160202195654');

INSERT INTO schema_migrations (version) VALUES ('20160203043347');

INSERT INTO schema_migrations (version) VALUES ('20160205153608');

INSERT INTO schema_migrations (version) VALUES ('20160209043602');

INSERT INTO schema_migrations (version) VALUES ('20160212063606');

INSERT INTO schema_migrations (version) VALUES ('20160215020819');

INSERT INTO schema_migrations (version) VALUES ('20160215022602');

INSERT INTO schema_migrations (version) VALUES ('20160216022106');

INSERT INTO schema_migrations (version) VALUES ('20160216054823');

INSERT INTO schema_migrations (version) VALUES ('20160217053313');

INSERT INTO schema_migrations (version) VALUES ('20160218053236');

INSERT INTO schema_migrations (version) VALUES ('20160222223309');

INSERT INTO schema_migrations (version) VALUES ('20160223040544');

INSERT INTO schema_migrations (version) VALUES ('20160223050808');

INSERT INTO schema_migrations (version) VALUES ('20160229065423');

INSERT INTO schema_migrations (version) VALUES ('20160302020531');

INSERT INTO schema_migrations (version) VALUES ('20160308034305');

INSERT INTO schema_migrations (version) VALUES ('20160310225707');

INSERT INTO schema_migrations (version) VALUES ('20160311161727');

INSERT INTO schema_migrations (version) VALUES ('20160316044236');

INSERT INTO schema_migrations (version) VALUES ('20160316045448');

INSERT INTO schema_migrations (version) VALUES ('20160321002728');

INSERT INTO schema_migrations (version) VALUES ('20160321052842');

INSERT INTO schema_migrations (version) VALUES ('20160321053840');

INSERT INTO schema_migrations (version) VALUES ('20160322012427');

INSERT INTO schema_migrations (version) VALUES ('20160328123156');

INSERT INTO schema_migrations (version) VALUES ('20160331152023');

INSERT INTO schema_migrations (version) VALUES ('20160405063726');

INSERT INTO schema_migrations (version) VALUES ('20160405094034');

INSERT INTO schema_migrations (version) VALUES ('20160406155731');

INSERT INTO schema_migrations (version) VALUES ('20160408024038');

INSERT INTO schema_migrations (version) VALUES ('20160410074625');

INSERT INTO schema_migrations (version) VALUES ('20160410235811');

INSERT INTO schema_migrations (version) VALUES ('20160411214700');

INSERT INTO schema_migrations (version) VALUES ('20160413035400');

INSERT INTO schema_migrations (version) VALUES ('20160413082756');

INSERT INTO schema_migrations (version) VALUES ('20160413092439');

INSERT INTO schema_migrations (version) VALUES ('20160426015604');

INSERT INTO schema_migrations (version) VALUES ('20160427052835');

INSERT INTO schema_migrations (version) VALUES ('20160428204352');

INSERT INTO schema_migrations (version) VALUES ('20160512230210');

INSERT INTO schema_migrations (version) VALUES ('20160516233017');

INSERT INTO schema_migrations (version) VALUES ('20160531124224');

INSERT INTO schema_migrations (version) VALUES ('20160531235018');

INSERT INTO schema_migrations (version) VALUES ('20160601041853');

INSERT INTO schema_migrations (version) VALUES ('20160614013227');

INSERT INTO schema_migrations (version) VALUES ('20160615092915');

INSERT INTO schema_migrations (version) VALUES ('20160630100531');

INSERT INTO schema_migrations (version) VALUES ('20160701171544');

INSERT INTO schema_migrations (version) VALUES ('20160707102309');

INSERT INTO schema_migrations (version) VALUES ('20160713100115');

INSERT INTO schema_migrations (version) VALUES ('20160718185835');

INSERT INTO schema_migrations (version) VALUES ('20160720124018');

INSERT INTO schema_migrations (version) VALUES ('20160727014602');

INSERT INTO schema_migrations (version) VALUES ('20160802150056');

INSERT INTO schema_migrations (version) VALUES ('20160802183524');

INSERT INTO schema_migrations (version) VALUES ('20160805082330');

INSERT INTO schema_migrations (version) VALUES ('20160824002846');

INSERT INTO schema_migrations (version) VALUES ('20160824055520');

INSERT INTO schema_migrations (version) VALUES ('20160824055611');

INSERT INTO schema_migrations (version) VALUES ('20160902140625');

INSERT INTO schema_migrations (version) VALUES ('20160909211938');

INSERT INTO schema_migrations (version) VALUES ('20160910010242');

INSERT INTO schema_migrations (version) VALUES ('20160915133006');

INSERT INTO schema_migrations (version) VALUES ('20160917100817');

INSERT INTO schema_migrations (version) VALUES ('20160921025247');

INSERT INTO schema_migrations (version) VALUES ('20161011102614');

INSERT INTO schema_migrations (version) VALUES ('20161017175249');

INSERT INTO schema_migrations (version) VALUES ('20161020143229');

INSERT INTO schema_migrations (version) VALUES ('20161022230235');

INSERT INTO schema_migrations (version) VALUES ('20161025152907');

INSERT INTO schema_migrations (version) VALUES ('20161031155310');

INSERT INTO schema_migrations (version) VALUES ('20161101111038');

INSERT INTO schema_migrations (version) VALUES ('20161101153915');

INSERT INTO schema_migrations (version) VALUES ('20161110140134');

INSERT INTO schema_migrations (version) VALUES ('20161117012806');

INSERT INTO schema_migrations (version) VALUES ('20161117115933');

INSERT INTO schema_migrations (version) VALUES ('20161118172620');

INSERT INTO schema_migrations (version) VALUES ('20161118172622');

INSERT INTO schema_migrations (version) VALUES ('20161118173603');

INSERT INTO schema_migrations (version) VALUES ('20161118173743');

INSERT INTO schema_migrations (version) VALUES ('20161119142856');

INSERT INTO schema_migrations (version) VALUES ('20161121185106');

INSERT INTO schema_migrations (version) VALUES ('20161121221359');

INSERT INTO schema_migrations (version) VALUES ('20161122172949');

INSERT INTO schema_migrations (version) VALUES ('20161123005430');

INSERT INTO schema_migrations (version) VALUES ('20161123132241');

INSERT INTO schema_migrations (version) VALUES ('20161125233314');

INSERT INTO schema_migrations (version) VALUES ('20161129214901');

INSERT INTO schema_migrations (version) VALUES ('20161208020352');

INSERT INTO schema_migrations (version) VALUES ('20161209210719');

INSERT INTO schema_migrations (version) VALUES ('20161213021906');

INSERT INTO schema_migrations (version) VALUES ('20161219200009');

INSERT INTO schema_migrations (version) VALUES ('20161220101024');

INSERT INTO schema_migrations (version) VALUES ('20161223212006');

INSERT INTO schema_migrations (version) VALUES ('20161223213100');

INSERT INTO schema_migrations (version) VALUES ('20170106163718');

INSERT INTO schema_migrations (version) VALUES ('20170110200117');

INSERT INTO schema_migrations (version) VALUES ('20170110220500');

INSERT INTO schema_migrations (version) VALUES ('20170110223040');

INSERT INTO schema_migrations (version) VALUES ('20170118224029');

INSERT INTO schema_migrations (version) VALUES ('20170119113933');

INSERT INTO schema_migrations (version) VALUES ('20170120133530');

INSERT INTO schema_migrations (version) VALUES ('20170125133929');

INSERT INTO schema_migrations (version) VALUES ('20170125213904');

INSERT INTO schema_migrations (version) VALUES ('20170126010742');

INSERT INTO schema_migrations (version) VALUES ('20170126183738');

INSERT INTO schema_migrations (version) VALUES ('20170126233011');

INSERT INTO schema_migrations (version) VALUES ('20170127005811');

INSERT INTO schema_migrations (version) VALUES ('20170201000041');

INSERT INTO schema_migrations (version) VALUES ('20170207033301');

INSERT INTO schema_migrations (version) VALUES ('20170210204344');

INSERT INTO schema_migrations (version) VALUES ('20170213164840');

INSERT INTO schema_migrations (version) VALUES ('20170217005814');

INSERT INTO schema_migrations (version) VALUES ('20170221074155');

INSERT INTO schema_migrations (version) VALUES ('20170222042555');

INSERT INTO schema_migrations (version) VALUES ('20170222071204');

INSERT INTO schema_migrations (version) VALUES ('20170224035644');

INSERT INTO schema_migrations (version) VALUES ('20170227003049');

INSERT INTO schema_migrations (version) VALUES ('20170314135334');

INSERT INTO schema_migrations (version) VALUES ('20170314140248');

INSERT INTO schema_migrations (version) VALUES ('20170315050020');

INSERT INTO schema_migrations (version) VALUES ('20170315061105');

INSERT INTO schema_migrations (version) VALUES ('20170322005437');

INSERT INTO schema_migrations (version) VALUES ('20170323004734');

INSERT INTO schema_migrations (version) VALUES ('20170324225539');

INSERT INTO schema_migrations (version) VALUES ('20170326053740');

INSERT INTO schema_migrations (version) VALUES ('20170331000015');

INSERT INTO schema_migrations (version) VALUES ('20170403233233');

INSERT INTO schema_migrations (version) VALUES ('20170403233506');

INSERT INTO schema_migrations (version) VALUES ('20170403234144');

INSERT INTO schema_migrations (version) VALUES ('20170404001857');

INSERT INTO schema_migrations (version) VALUES ('20170405182914');

INSERT INTO schema_migrations (version) VALUES ('20170410001828');

INSERT INTO schema_migrations (version) VALUES ('20170410043635');

INSERT INTO schema_migrations (version) VALUES ('20170411221422');

INSERT INTO schema_migrations (version) VALUES ('20170417213117');

INSERT INTO schema_migrations (version) VALUES ('20170418210655');

INSERT INTO schema_migrations (version) VALUES ('20170420003828');

INSERT INTO schema_migrations (version) VALUES ('20170424042211');

INSERT INTO schema_migrations (version) VALUES ('20170425002532');

INSERT INTO schema_migrations (version) VALUES ('20170425023634');

INSERT INTO schema_migrations (version) VALUES ('20170427064412');

INSERT INTO schema_migrations (version) VALUES ('20170427110511');

INSERT INTO schema_migrations (version) VALUES ('20170427165431');

INSERT INTO schema_migrations (version) VALUES ('20170427231827');

INSERT INTO schema_migrations (version) VALUES ('20170503004457');

INSERT INTO schema_migrations (version) VALUES ('20170503074637');

INSERT INTO schema_migrations (version) VALUES ('20170504163111');

INSERT INTO schema_migrations (version) VALUES ('20170511135448');

INSERT INTO schema_migrations (version) VALUES ('20170515210340');

INSERT INTO schema_migrations (version) VALUES ('20170516070445');

INSERT INTO schema_migrations (version) VALUES ('20170518161536');

INSERT INTO schema_migrations (version) VALUES ('20170519132704');

INSERT INTO schema_migrations (version) VALUES ('20170523095107');

INSERT INTO schema_migrations (version) VALUES ('20170524184517');

INSERT INTO schema_migrations (version) VALUES ('20170527060310');

INSERT INTO schema_migrations (version) VALUES ('20170527063724');

INSERT INTO schema_migrations (version) VALUES ('20170527071529');

INSERT INTO schema_migrations (version) VALUES ('20170601014655');

INSERT INTO schema_migrations (version) VALUES ('20170602062951');

INSERT INTO schema_migrations (version) VALUES ('20170603045344');

INSERT INTO schema_migrations (version) VALUES ('20170606004911');

INSERT INTO schema_migrations (version) VALUES ('20170607040735');

INSERT INTO schema_migrations (version) VALUES ('20170607184815');

INSERT INTO schema_migrations (version) VALUES ('20170608215959');

INSERT INTO schema_migrations (version) VALUES ('20170609001931');

INSERT INTO schema_migrations (version) VALUES ('20170612150350');

INSERT INTO schema_migrations (version) VALUES ('20170612215626');

INSERT INTO schema_migrations (version) VALUES ('20170615180547');

INSERT INTO schema_migrations (version) VALUES ('20170620220113');

INSERT INTO schema_migrations (version) VALUES ('20170623185316');

INSERT INTO schema_migrations (version) VALUES ('20170721184956');

INSERT INTO schema_migrations (version) VALUES ('20170724213118');

INSERT INTO schema_migrations (version) VALUES ('20170809211839');

INSERT INTO schema_migrations (version) VALUES ('20170816220818');

INSERT INTO schema_migrations (version) VALUES ('20170817173805');

INSERT INTO schema_migrations (version) VALUES ('20170821173721');

INSERT INTO schema_migrations (version) VALUES ('20170828194844');

INSERT INTO schema_migrations (version) VALUES ('20170905235000');

INSERT INTO schema_migrations (version) VALUES ('20170906001235');

INSERT INTO schema_migrations (version) VALUES ('20170906170913');

INSERT INTO schema_migrations (version) VALUES ('20170907211051');

INSERT INTO schema_migrations (version) VALUES ('20170908182740');

INSERT INTO schema_migrations (version) VALUES ('20170914013707');

INSERT INTO schema_migrations (version) VALUES ('20170927181851');

INSERT INTO schema_migrations (version) VALUES ('20170928202521');

INSERT INTO schema_migrations (version) VALUES ('20171013172806');

INSERT INTO schema_migrations (version) VALUES ('20171016230612');

INSERT INTO schema_migrations (version) VALUES ('20171101200751');

INSERT INTO schema_migrations (version) VALUES ('20171114001834');

INSERT INTO schema_migrations (version) VALUES ('20171115172748');

INSERT INTO schema_migrations (version) VALUES ('20171116214623');

INSERT INTO schema_migrations (version) VALUES ('20171127052028');

INSERT INTO schema_migrations (version) VALUES ('20171127212333');

INSERT INTO schema_migrations (version) VALUES ('20171207195245');

INSERT INTO schema_migrations (version) VALUES ('20171216185833');

INSERT INTO schema_migrations (version) VALUES ('20171219203151');

INSERT INTO schema_migrations (version) VALUES ('20180102175041');

INSERT INTO schema_migrations (version) VALUES ('20180103184321');

INSERT INTO schema_migrations (version) VALUES ('20180105234451');

INSERT INTO schema_migrations (version) VALUES ('20180105235603');

INSERT INTO schema_migrations (version) VALUES ('20180111190922');

INSERT INTO schema_migrations (version) VALUES ('20180118062620');

INSERT INTO schema_migrations (version) VALUES ('20180131220110');

INSERT INTO schema_migrations (version) VALUES ('20180212070230');

INSERT INTO schema_migrations (version) VALUES ('20180212213652');

INSERT INTO schema_migrations (version) VALUES ('20180213212256');

INSERT INTO schema_migrations (version) VALUES ('20180220010932');

INSERT INTO schema_migrations (version) VALUES ('20180220231314');

INSERT INTO schema_migrations (version) VALUES ('20180221014607');

INSERT INTO schema_migrations (version) VALUES ('20180222192328');

INSERT INTO schema_migrations (version) VALUES ('20180223185047');

INSERT INTO schema_migrations (version) VALUES ('20180225073927');

INSERT INTO schema_migrations (version) VALUES ('20180225165655');

INSERT INTO schema_migrations (version) VALUES ('20180225215224');

INSERT INTO schema_migrations (version) VALUES ('20180225220958');

INSERT INTO schema_migrations (version) VALUES ('20180227181112');

INSERT INTO schema_migrations (version) VALUES ('20180227234830');

INSERT INTO schema_migrations (version) VALUES ('20180302005846');

INSERT INTO schema_migrations (version) VALUES ('20180309052001');

INSERT INTO schema_migrations (version) VALUES ('20180315032843');

INSERT INTO schema_migrations (version) VALUES ('20180403192310');

INSERT INTO schema_migrations (version) VALUES ('20180403210453');

INSERT INTO schema_migrations (version) VALUES ('20180404121555');

INSERT INTO schema_migrations (version) VALUES ('20180419180056');

INSERT INTO schema_migrations (version) VALUES ('20180430235008');

INSERT INTO schema_migrations (version) VALUES ('20180514050920');

INSERT INTO schema_migrations (version) VALUES ('20180526215302');

INSERT INTO schema_migrations (version) VALUES ('20180526220118');

INSERT INTO schema_migrations (version) VALUES ('20180526225425');

INSERT INTO schema_migrations (version) VALUES ('20180526232527');

INSERT INTO schema_migrations (version) VALUES ('20180526232944');

INSERT INTO schema_migrations (version) VALUES ('20180527002231');

INSERT INTO schema_migrations (version) VALUES ('20180527003945');

INSERT INTO schema_migrations (version) VALUES ('20180527004343');

INSERT INTO schema_migrations (version) VALUES ('20180527004738');

INSERT INTO schema_migrations (version) VALUES ('20180629170302');

INSERT INTO schema_migrations (version) VALUES ('20180717203709');

INSERT INTO schema_migrations (version) VALUES ('20180803233733');

INSERT INTO schema_migrations (version) VALUES ('20180815070122');

INSERT INTO schema_migrations (version) VALUES ('20180904045723');

INSERT INTO schema_migrations (version) VALUES ('20181005032844');

INSERT INTO schema_migrations (version) VALUES ('20181005033718');

INSERT INTO schema_migrations (version) VALUES ('20181005033839');

INSERT INTO schema_migrations (version) VALUES ('20181008013910');

INSERT INTO schema_migrations (version) VALUES ('20181105000355');

INSERT INTO schema_migrations (version) VALUES ('20181120231445');

INSERT INTO schema_migrations (version) VALUES ('20181121020632');

INSERT INTO schema_migrations (version) VALUES ('20181121225145');

INSERT INTO schema_migrations (version) VALUES ('20181123002244');