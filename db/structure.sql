--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: deals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE deals (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    permalink text NOT NULL,
    deal_uuid uuid NOT NULL
);


--
-- Name: followers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE followers (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    user_uuid uuid NOT NULL
);


--
-- Name: guru_deals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE guru_deals (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    deal_id uuid NOT NULL,
    guru_id uuid NOT NULL,
    is_cover boolean DEFAULT false,
    notes text
);


--
-- Name: guru_followers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE guru_followers (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    follower_id uuid NOT NULL,
    guru_id uuid NOT NULL
);


--
-- Name: gurus; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE gurus (
    id uuid DEFAULT uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone NOT NULL,
    user_uuid uuid NOT NULL,
    username text NOT NULL,
    avatar character varying,
    place character varying(50),
    page_title character varying,
    writeup text
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: deals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY deals
    ADD CONSTRAINT deals_pkey PRIMARY KEY (id);


--
-- Name: followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY followers
    ADD CONSTRAINT followers_pkey PRIMARY KEY (id);


--
-- Name: guru_deals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY guru_deals
    ADD CONSTRAINT guru_deals_pkey PRIMARY KEY (id);


--
-- Name: guru_followers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY guru_followers
    ADD CONSTRAINT guru_followers_pkey PRIMARY KEY (id);


--
-- Name: gurus_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY gurus
    ADD CONSTRAINT gurus_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150204000741');

INSERT INTO schema_migrations (version) VALUES ('20150717000741');

INSERT INTO schema_migrations (version) VALUES ('20150720000741');

INSERT INTO schema_migrations (version) VALUES ('20150720000742');

INSERT INTO schema_migrations (version) VALUES ('20150720000743');

INSERT INTO schema_migrations (version) VALUES ('20150720000744');

INSERT INTO schema_migrations (version) VALUES ('20150720000745');

INSERT INTO schema_migrations (version) VALUES ('20150720000746');

INSERT INTO schema_migrations (version) VALUES ('20150720000747');

INSERT INTO schema_migrations (version) VALUES ('20150720000748');

INSERT INTO schema_migrations (version) VALUES ('20150720000749');

