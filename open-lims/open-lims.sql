--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.1
-- Dumped by pg_dump version 9.1.1
-- Started on 2014-01-20 13:49:49

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 377 (class 3079 OID 74515)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3205 (class 0 OID 0)
-- Dependencies: 377
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 389 (class 1255 OID 159882)
-- Dependencies: 6
-- Name: concat(text, text); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION concat(text, text) RETURNS text
    LANGUAGE sql
    AS $_$SELECT
CASE WHEN $1 IS NULL THEN $2
WHEN $2 IS NULL THEN $1
ELSE $1 || $2
END$_$;


ALTER FUNCTION public.concat(text, text) OWNER TO dbadmin;

--
-- TOC entry 392 (class 1255 OID 160725)
-- Dependencies: 1125 6
-- Name: get_all_file_versions(integer, integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION get_all_file_versions(integer, integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$DECLARE
file_record RECORD;
rec_return RECORD;
BEGIN
	
	IF $2 IS NULL THEN

		FOR file_record IN SELECT id FROM core_file_versions WHERE previous_version_id=id AND toid=$1 ORDER BY version
		LOOP

			IF file_record.id IS NOT NULL THEN

				RETURN NEXT file_record.id;

				FOR rec_return IN select * from get_all_file_versions($1, file_record.id) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	ELSE

		FOR file_record IN SELECT id FROM core_file_versions WHERE previous_version_id=$2 AND toid=$1 AND previous_version_id != id ORDER BY version
		LOOP

			IF file_record.id IS NOT NULL THEN
				
				RETURN NEXT file_record.id;

				FOR rec_return IN select * from get_all_file_versions($1, file_record.id) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	END IF;

	RETURN;	

END;$_$;


ALTER FUNCTION public.get_all_file_versions(integer, integer) OWNER TO dbadmin;

--
-- TOC entry 393 (class 1255 OID 160726)
-- Dependencies: 6 1125
-- Name: get_all_parameter_versions(integer, integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION get_all_parameter_versions(integer, integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$DECLARE
parameter_record RECORD;
rec_return RECORD;
BEGIN
	
	IF $2 IS NULL THEN

		FOR parameter_record IN SELECT id FROM core_data_parameter_versions WHERE previous_version_id=id AND parameter_id=$1 ORDER BY version
		LOOP

			IF parameter_record.id IS NOT NULL THEN

				RETURN NEXT parameter_record.id;

				FOR rec_return IN select * from get_all_parameter_versions($1, parameter_record.id) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	ELSE

		FOR parameter_record IN SELECT id FROM core_data_parameter_versions WHERE previous_version_id=$2 AND parameter_id=$1 AND previous_version_id != id ORDER BY version
		LOOP

			IF parameter_record.id IS NOT NULL THEN
				
				RETURN NEXT parameter_record.id;

				FOR rec_return IN select * from get_all_parameter_versions($1, value_record.id) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	END IF;

	RETURN;	

END;$_$;


ALTER FUNCTION public.get_all_parameter_versions(integer, integer) OWNER TO dbadmin;

--
-- TOC entry 394 (class 1255 OID 160727)
-- Dependencies: 6 1125
-- Name: get_all_value_versions(integer, integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION get_all_value_versions(integer, integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$DECLARE
value_record RECORD;
rec_return RECORD;
BEGIN
	
	IF $2 IS NULL THEN

		FOR value_record IN SELECT id FROM core_value_versions WHERE previous_version_id=id AND toid=$1 ORDER BY version
		LOOP

			IF value_record.id IS NOT NULL THEN

				RETURN NEXT value_record.id;

				FOR rec_return IN select * from get_all_value_versions($1, value_record.id) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	ELSE

		FOR value_record IN SELECT id FROM core_value_versions WHERE previous_version_id=$2 AND toid=$1 AND previous_version_id != id ORDER BY version
		LOOP

			IF value_record.id IS NOT NULL THEN
				
				RETURN NEXT value_record.id;

				FOR rec_return IN select * from get_all_value_versions($1, value_record.id) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	END IF;

	RETURN;	

END;

$_$;


ALTER FUNCTION public.get_all_value_versions(integer, integer) OWNER TO dbadmin;

--
-- TOC entry 391 (class 1255 OID 159992)
-- Dependencies: 1125 6
-- Name: get_organisation_unit_childs(integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION get_organisation_unit_childs(integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$DECLARE
organisation_unit_record RECORD;
rec_record RECORD;
BEGIN

	IF $1 IS NOT NULL THEN

		RETURN NEXT $1;
		
		FOR organisation_unit_record IN SELECT id FROM core_organisation_units WHERE toid=$1 AND id != toid
		LOOP

			IF organisation_unit_record.id IS NOT NULL THEN

				FOR rec_record IN SELECT * FROM get_organisation_unit_childs(organisation_unit_record.id) AS id
				LOOP

					RETURN NEXT rec_record.id;

				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	ELSE

		RETURN;

	END IF;

	RETURN;	

END;$_$;


ALTER FUNCTION public.get_organisation_unit_childs(integer) OWNER TO dbadmin;

--
-- TOC entry 396 (class 1255 OID 161158)
-- Dependencies: 1125 6
-- Name: get_project_id_by_folder_id(integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION get_project_id_by_folder_id(folder_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE
project_id INTEGER;
parent_folder_id INTEGER;
BEGIN
	

	IF $1 IS NOT NULL THEN

		SELECT core_project_has_folder.project_id INTO project_id FROM core_project_has_folder WHERE core_project_has_folder.folder_id = $1;
		IF project_id IS NOT NULL THEN
			RETURN project_id;
		ELSE
			SELECT core_folders.id INTO parent_folder_id FROM core_folders WHERE core_folders.data_entity_id =
				(SELECT data_entity_pid FROM core_data_entity_has_data_entities WHERE data_entity_cid = (SELECT data_entity_id FROM core_folders WHERE id=folder_id) AND (data_entity_pid IN (SELECT data_entity_id FROM core_folders)));

			RETURN get_project_id_by_folder_id(parent_folder_id);
		END IF;

		

	ELSE

		RETURN NULL;

	END IF;

END;$_$;


ALTER FUNCTION public.get_project_id_by_folder_id(folder_id integer) OWNER TO dbadmin;

--
-- TOC entry 397 (class 1255 OID 161159)
-- Dependencies: 1125 6
-- Name: get_project_supplementary_folder(integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION get_project_supplementary_folder(folder_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE
supplementary_folder_id INTEGER;
BEGIN
	

	IF $1 IS NOT NULL THEN

		SELECT core_folders.id INTO supplementary_folder_id FROM core_folders WHERE core_folders.data_entity_id IN
				(SELECT data_entity_cid FROM core_data_entity_has_data_entities WHERE data_entity_pid = (SELECT data_entity_id FROM core_folders WHERE id=folder_id) AND (data_entity_cid IN (SELECT data_entity_id FROM core_folders)))
				AND TRIM(LOWER(name)) = 'supplementary';

		RETURN supplementary_folder_id;

	ELSE

		RETURN NULL;

	END IF;

END;$_$;


ALTER FUNCTION public.get_project_supplementary_folder(folder_id integer) OWNER TO dbadmin;

--
-- TOC entry 402 (class 1255 OID 161351)
-- Dependencies: 1125 6
-- Name: get_sample_id_by_folder_id(integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION get_sample_id_by_folder_id(folder_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$DECLARE
sample_id INTEGER;
parent_folder_id INTEGER;
BEGIN
	

	IF $1 IS NOT NULL THEN

		SELECT core_sample_has_folder.sample_id INTO sample_id FROM core_sample_has_folder WHERE core_sample_has_folder.folder_id = $1;
		IF sample_id IS NOT NULL THEN
			RETURN sample_id;
		ELSE
			SELECT core_folders.id INTO parent_folder_id FROM core_folders WHERE core_folders.data_entity_id =
				(SELECT data_entity_pid FROM core_data_entity_has_data_entities WHERE data_entity_cid = (SELECT data_entity_id FROM core_folders WHERE id=folder_id) AND (data_entity_pid IN (SELECT data_entity_id FROM core_folders)));

			RETURN get_sample_id_by_folder_id(parent_folder_id);
		END IF;

		

	ELSE

		RETURN NULL;

	END IF;

END;$_$;


ALTER FUNCTION public.get_sample_id_by_folder_id(folder_id integer) OWNER TO dbadmin;

--
-- TOC entry 390 (class 1255 OID 159883)
-- Dependencies: 6
-- Name: nameconcat(text, text); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION nameconcat(text, text) RETURNS text
    LANGUAGE sql
    AS $_$SELECT
CASE WHEN $1 IS NULL THEN $2
WHEN $2 IS NULL THEN $1
ELSE $1 || ' ' || $2 END$_$;


ALTER FUNCTION public.nameconcat(text, text) OWNER TO dbadmin;

--
-- TOC entry 398 (class 1255 OID 161160)
-- Dependencies: 1125 6
-- Name: project_permission_group(integer, integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION project_permission_group(project_id integer, group_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE
	permission_rec RECORD;
	position1_rec RECORD; 
	position4_rec RECORD;   
	position5_rec RECORD;         
BEGIN
	FOR permission_rec IN SELECT CAST(permission::BIT(7) AS TEXT) AS permission FROM core_project_permissions WHERE core_project_permissions.project_id = $1 AND core_project_permissions.group_id = $2
LOOP

	SELECT INTO position1_rec SUBSTRING(permission_rec.permission FROM 1 FOR 1) AS resultchar;
	SELECT INTO position4_rec SUBSTRING(permission_rec.permission FROM 4 FOR 1) AS resultchar;
	SELECT INTO position5_rec SUBSTRING(permission_rec.permission FROM 5 FOR 1) AS resultchar;

IF position1_rec.resultchar = '1' THEN
	RETURN TRUE;
ELSE

	IF position4_rec.resultchar = '1' THEN
		RETURN TRUE;
	ELSE

		IF position5_rec.resultchar = '1' THEN
			RETURN TRUE;
		END IF;

	END IF;

END IF;
END LOOP;
RETURN FALSE;
END;$_$;


ALTER FUNCTION public.project_permission_group(project_id integer, group_id integer) OWNER TO dbadmin;

--
-- TOC entry 399 (class 1255 OID 161161)
-- Dependencies: 1125 6
-- Name: project_permission_organisation_unit(integer, integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION project_permission_organisation_unit(project_id integer, organisation_unit_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE
	permission_rec RECORD;
	position1_rec RECORD; 
	position4_rec RECORD;   
	position5_rec RECORD;         
BEGIN
	FOR permission_rec IN SELECT CAST(permission::BIT(7) AS TEXT) AS permission FROM core_project_permissions WHERE core_project_permissions.project_id = $1 AND core_project_permissions.organisation_unit_id = $2
LOOP

	SELECT INTO position1_rec SUBSTRING(permission_rec.permission FROM 1 FOR 1) AS resultchar;
	SELECT INTO position4_rec SUBSTRING(permission_rec.permission FROM 4 FOR 1) AS resultchar;
	SELECT INTO position5_rec SUBSTRING(permission_rec.permission FROM 5 FOR 1) AS resultchar;

IF position1_rec.resultchar = '1' THEN
	RETURN TRUE;
ELSE

	IF position4_rec.resultchar = '1' THEN
		RETURN TRUE;
	ELSE

		IF position5_rec.resultchar = '1' THEN
			RETURN TRUE;
		END IF;

	END IF;

END IF;
END LOOP;
RETURN FALSE;
END;$_$;


ALTER FUNCTION public.project_permission_organisation_unit(project_id integer, organisation_unit_id integer) OWNER TO dbadmin;

--
-- TOC entry 400 (class 1255 OID 161162)
-- Dependencies: 6 1125
-- Name: project_permission_user(integer, integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION project_permission_user(project_id integer, user_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$DECLARE
	permission_rec RECORD;
	position1_rec RECORD; 
	position4_rec RECORD;   
	position5_rec RECORD;         
BEGIN
	FOR permission_rec IN SELECT CAST(permission::BIT(7) AS TEXT) AS permission FROM core_project_permissions WHERE core_project_permissions.project_id = $1 AND core_project_permissions.user_id = $2
LOOP

	SELECT INTO position1_rec SUBSTRING(permission_rec.permission FROM 1 FOR 1) AS resultchar;
	SELECT INTO position4_rec SUBSTRING(permission_rec.permission FROM 4 FOR 1) AS resultchar;
	SELECT INTO position5_rec SUBSTRING(permission_rec.permission FROM 5 FOR 1) AS resultchar;

IF position1_rec.resultchar = '1' THEN
	RETURN TRUE;
ELSE

	IF position4_rec.resultchar = '1' THEN
		RETURN TRUE;
	ELSE

		IF position5_rec.resultchar = '1' THEN
			RETURN TRUE;
		END IF;

	END IF;

END IF;
END LOOP;
RETURN FALSE;
END;$_$;


ALTER FUNCTION public.project_permission_user(project_id integer, user_id integer) OWNER TO dbadmin;

--
-- TOC entry 401 (class 1255 OID 161163)
-- Dependencies: 6 1125
-- Name: search_get_project_subprojects(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION search_get_project_subprojects(integer, integer, integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$DECLARE
project_record RECORD;
rec_return RECORD;
BEGIN
	
	IF $3 IS NULL THEN

	IF $1 IS NOT NULL THEN

		FOR project_record IN SELECT id FROM core_projects WHERE toid_organ_unit=$1 AND toid_project IS NULL
		LOOP

			IF project_record.id IS NOT NULL THEN

				RETURN NEXT project_record.id;

				FOR rec_return IN select * from search_get_project_subprojects(NULL, project_record.id, NULL) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	ELSE

		FOR project_record IN SELECT id FROM core_projects WHERE toid_project=$2 AND toid_organ_unit IS NULL
		LOOP

			IF project_record.id IS NOT NULL THEN

				RETURN NEXT project_record.id;

				FOR rec_return IN select * from search_get_project_subprojects(NULL, project_record.id, NULL) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	END IF;

	ELSE

	IF $1 IS NOT NULL THEN

		FOR project_record IN SELECT id FROM core_projects WHERE toid_organ_unit=$1 AND toid_project IS NULL AND template_id = $3
		LOOP

			IF project_record.id IS NOT NULL THEN

				RETURN NEXT project_record.id;

				FOR rec_return IN select * from search_get_project_subprojects(NULL, project_record.id, NULL) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	ELSE

		FOR project_record IN SELECT id FROM core_projects WHERE toid_project=$2 AND toid_organ_unit IS NULL AND template_id = $3
		LOOP

			IF project_record.id IS NOT NULL THEN

				RETURN NEXT project_record.id;

				FOR rec_return IN select * from search_get_project_subprojects(NULL, project_record.id, NULL) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	END IF;

	END IF;

	RETURN;	

END;$_$;


ALTER FUNCTION public.search_get_project_subprojects(integer, integer, integer) OWNER TO dbadmin;

--
-- TOC entry 395 (class 1255 OID 160728)
-- Dependencies: 1125 6
-- Name: search_get_sub_folders(integer); Type: FUNCTION; Schema: public; Owner: dbadmin
--

CREATE FUNCTION search_get_sub_folders(integer) RETURNS SETOF integer
    LANGUAGE plpgsql
    AS $_$DECLARE
folder_record RECORD;
rec_return RECORD;
BEGIN
	

	IF $1 IS NOT NULL THEN

		FOR folder_record IN SELECT data_entity_cid FROM core_data_entity_has_data_entities WHERE data_entity_pid = $1 AND (data_entity_cid IN (SELECT data_entity_id FROM core_folders))
		LOOP

			IF folder_record.data_entity_cid IS NOT NULL THEN

				RETURN NEXT folder_record.data_entity_cid;

				FOR rec_return IN select * from search_get_sub_folders(folder_record.data_entity_cid) AS subid
				LOOP
					RETURN NEXT rec_return.subid;
				END LOOP;

			ELSE
				RETURN;
			END IF;

		END LOOP;

	ELSE

		RETURN;

	END IF;

	RETURN;	

END;$_$;


ALTER FUNCTION public.search_get_sub_folders(integer) OWNER TO dbadmin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 162 (class 1259 OID 159342)
-- Dependencies: 6
-- Name: core_base_batch_runs; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_batch_runs (
    id integer NOT NULL,
    binary_id integer,
    status integer,
    create_datetime timestamp with time zone,
    start_datetime timestamp with time zone,
    end_datetime timestamp with time zone,
    last_lifesign timestamp with time zone,
    user_id integer,
    type_id integer
);


ALTER TABLE public.core_base_batch_runs OWNER TO dbadmin;

--
-- TOC entry 161 (class 1259 OID 159340)
-- Dependencies: 162 6
-- Name: core_base_batch_runs_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_batch_runs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_batch_runs_id_seq OWNER TO dbadmin;

--
-- TOC entry 3206 (class 0 OID 0)
-- Dependencies: 161
-- Name: core_base_batch_runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_batch_runs_id_seq OWNED BY core_base_batch_runs.id;


--
-- TOC entry 3207 (class 0 OID 0)
-- Dependencies: 161
-- Name: core_base_batch_runs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_batch_runs_id_seq', 1, false);


--
-- TOC entry 164 (class 1259 OID 159350)
-- Dependencies: 6
-- Name: core_base_batch_types; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_batch_types (
    id integer NOT NULL,
    name text,
    internal_name text,
    binary_id integer
);


ALTER TABLE public.core_base_batch_types OWNER TO dbadmin;

--
-- TOC entry 163 (class 1259 OID 159348)
-- Dependencies: 164 6
-- Name: core_base_batch_types_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_batch_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_batch_types_id_seq OWNER TO dbadmin;

--
-- TOC entry 3208 (class 0 OID 0)
-- Dependencies: 163
-- Name: core_base_batch_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_batch_types_id_seq OWNED BY core_base_batch_types.id;


--
-- TOC entry 3209 (class 0 OID 0)
-- Dependencies: 163
-- Name: core_base_batch_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_batch_types_id_seq', 1, false);


--
-- TOC entry 166 (class 1259 OID 159363)
-- Dependencies: 6
-- Name: core_base_event_listeners; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_event_listeners (
    id integer NOT NULL,
    include_id integer,
    class_name text
);


ALTER TABLE public.core_base_event_listeners OWNER TO dbadmin;

--
-- TOC entry 165 (class 1259 OID 159361)
-- Dependencies: 166 6
-- Name: core_base_event_listeners_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_event_listeners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_event_listeners_id_seq OWNER TO dbadmin;

--
-- TOC entry 3210 (class 0 OID 0)
-- Dependencies: 165
-- Name: core_base_event_listeners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_event_listeners_id_seq OWNED BY core_base_event_listeners.id;


--
-- TOC entry 3211 (class 0 OID 0)
-- Dependencies: 165
-- Name: core_base_event_listeners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_event_listeners_id_seq', 34, true);


--
-- TOC entry 168 (class 1259 OID 159374)
-- Dependencies: 6
-- Name: core_base_include_files; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_include_files (
    id integer NOT NULL,
    include_id integer,
    name text,
    checksum character(32)
);


ALTER TABLE public.core_base_include_files OWNER TO dbadmin;

--
-- TOC entry 167 (class 1259 OID 159372)
-- Dependencies: 168 6
-- Name: core_base_include_files_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_include_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_include_files_id_seq OWNER TO dbadmin;

--
-- TOC entry 3212 (class 0 OID 0)
-- Dependencies: 167
-- Name: core_base_include_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_include_files_id_seq OWNED BY core_base_include_files.id;


--
-- TOC entry 3213 (class 0 OID 0)
-- Dependencies: 167
-- Name: core_base_include_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_include_files_id_seq', 33, true);


--
-- TOC entry 170 (class 1259 OID 159385)
-- Dependencies: 6
-- Name: core_base_include_functions; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_include_functions (
    id integer NOT NULL,
    include text,
    function_name text,
    db_version text
);


ALTER TABLE public.core_base_include_functions OWNER TO dbadmin;

--
-- TOC entry 169 (class 1259 OID 159383)
-- Dependencies: 170 6
-- Name: core_base_include_functions_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_include_functions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_include_functions_id_seq OWNER TO dbadmin;

--
-- TOC entry 3214 (class 0 OID 0)
-- Dependencies: 169
-- Name: core_base_include_functions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_include_functions_id_seq OWNED BY core_base_include_functions.id;


--
-- TOC entry 3215 (class 0 OID 0)
-- Dependencies: 169
-- Name: core_base_include_functions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_include_functions_id_seq', 1, false);


--
-- TOC entry 172 (class 1259 OID 159396)
-- Dependencies: 6
-- Name: core_base_include_tables; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_include_tables (
    id integer NOT NULL,
    include text,
    table_name text,
    db_version text
);


ALTER TABLE public.core_base_include_tables OWNER TO dbadmin;

--
-- TOC entry 171 (class 1259 OID 159394)
-- Dependencies: 172 6
-- Name: core_base_include_tables_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_include_tables_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_include_tables_id_seq OWNER TO dbadmin;

--
-- TOC entry 3216 (class 0 OID 0)
-- Dependencies: 171
-- Name: core_base_include_tables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_include_tables_id_seq OWNED BY core_base_include_tables.id;


--
-- TOC entry 3217 (class 0 OID 0)
-- Dependencies: 171
-- Name: core_base_include_tables_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_include_tables_id_seq', 141, true);


--
-- TOC entry 174 (class 1259 OID 159407)
-- Dependencies: 6
-- Name: core_base_includes; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_includes (
    id integer NOT NULL,
    name text,
    folder text,
    db_version text
);


ALTER TABLE public.core_base_includes OWNER TO dbadmin;

--
-- TOC entry 173 (class 1259 OID 159405)
-- Dependencies: 6 174
-- Name: core_base_includes_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_includes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_includes_id_seq OWNER TO dbadmin;

--
-- TOC entry 3218 (class 0 OID 0)
-- Dependencies: 173
-- Name: core_base_includes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_includes_id_seq OWNED BY core_base_includes.id;


--
-- TOC entry 3219 (class 0 OID 0)
-- Dependencies: 173
-- Name: core_base_includes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_includes_id_seq', 11, true);


--
-- TOC entry 176 (class 1259 OID 159418)
-- Dependencies: 6
-- Name: core_base_measuring_unit_categories; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_measuring_unit_categories (
    id integer NOT NULL,
    name text,
    created_by_user boolean
);


ALTER TABLE public.core_base_measuring_unit_categories OWNER TO dbadmin;

--
-- TOC entry 175 (class 1259 OID 159416)
-- Dependencies: 6 176
-- Name: core_base_measuring_unit_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_measuring_unit_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_measuring_unit_categories_id_seq OWNER TO dbadmin;

--
-- TOC entry 3220 (class 0 OID 0)
-- Dependencies: 175
-- Name: core_base_measuring_unit_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_measuring_unit_categories_id_seq OWNED BY core_base_measuring_unit_categories.id;


--
-- TOC entry 3221 (class 0 OID 0)
-- Dependencies: 175
-- Name: core_base_measuring_unit_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_measuring_unit_categories_id_seq', 21, true);


--
-- TOC entry 178 (class 1259 OID 159429)
-- Dependencies: 6
-- Name: core_base_measuring_unit_ratios; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_measuring_unit_ratios (
    id integer NOT NULL,
    numerator_unit_id integer,
    numerator_unit_exponent integer,
    denominator_unit_id integer,
    denominator_unit_exponent integer
);


ALTER TABLE public.core_base_measuring_unit_ratios OWNER TO dbadmin;

--
-- TOC entry 177 (class 1259 OID 159427)
-- Dependencies: 178 6
-- Name: core_base_measuring_unit_ratios_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_measuring_unit_ratios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_measuring_unit_ratios_id_seq OWNER TO dbadmin;

--
-- TOC entry 3222 (class 0 OID 0)
-- Dependencies: 177
-- Name: core_base_measuring_unit_ratios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_measuring_unit_ratios_id_seq OWNED BY core_base_measuring_unit_ratios.id;


--
-- TOC entry 3223 (class 0 OID 0)
-- Dependencies: 177
-- Name: core_base_measuring_unit_ratios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_measuring_unit_ratios_id_seq', 4, true);


--
-- TOC entry 180 (class 1259 OID 159437)
-- Dependencies: 6
-- Name: core_base_measuring_units; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_measuring_units (
    id integer NOT NULL,
    base_id integer,
    category_id integer,
    name text,
    unit_symbol text,
    min_value double precision,
    max_value double precision,
    min_prefix_exponent integer,
    max_prefix_exponent integer,
    prefix_calculation_exponent integer,
    calculation text,
    type text,
    created_by_user boolean
);


ALTER TABLE public.core_base_measuring_units OWNER TO dbadmin;

--
-- TOC entry 179 (class 1259 OID 159435)
-- Dependencies: 6 180
-- Name: core_base_measuring_units_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_measuring_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_measuring_units_id_seq OWNER TO dbadmin;

--
-- TOC entry 3224 (class 0 OID 0)
-- Dependencies: 179
-- Name: core_base_measuring_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_measuring_units_id_seq OWNED BY core_base_measuring_units.id;


--
-- TOC entry 3225 (class 0 OID 0)
-- Dependencies: 179
-- Name: core_base_measuring_units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_measuring_units_id_seq', 31, true);


--
-- TOC entry 182 (class 1259 OID 159448)
-- Dependencies: 6
-- Name: core_base_module_dialogs; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_module_dialogs (
    id integer NOT NULL,
    module_id integer,
    dialog_type text,
    class_path text,
    class text,
    method text,
    internal_name text,
    language_address text,
    weight integer,
    disabled boolean
);


ALTER TABLE public.core_base_module_dialogs OWNER TO dbadmin;

--
-- TOC entry 181 (class 1259 OID 159446)
-- Dependencies: 6 182
-- Name: core_base_module_dialogs_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_module_dialogs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_module_dialogs_id_seq OWNER TO dbadmin;

--
-- TOC entry 3226 (class 0 OID 0)
-- Dependencies: 181
-- Name: core_base_module_dialogs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_module_dialogs_id_seq OWNED BY core_base_module_dialogs.id;


--
-- TOC entry 3227 (class 0 OID 0)
-- Dependencies: 181
-- Name: core_base_module_dialogs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_module_dialogs_id_seq', 78, true);


--
-- TOC entry 184 (class 1259 OID 159459)
-- Dependencies: 6
-- Name: core_base_module_files; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_module_files (
    id integer NOT NULL,
    module_id integer,
    name text,
    checksum character(32)
);


ALTER TABLE public.core_base_module_files OWNER TO dbadmin;

--
-- TOC entry 183 (class 1259 OID 159457)
-- Dependencies: 184 6
-- Name: core_base_module_files_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_module_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_module_files_id_seq OWNER TO dbadmin;

--
-- TOC entry 3228 (class 0 OID 0)
-- Dependencies: 183
-- Name: core_base_module_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_module_files_id_seq OWNED BY core_base_module_files.id;


--
-- TOC entry 3229 (class 0 OID 0)
-- Dependencies: 183
-- Name: core_base_module_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_module_files_id_seq', 25, true);


--
-- TOC entry 186 (class 1259 OID 159470)
-- Dependencies: 6
-- Name: core_base_module_links; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_module_links (
    id integer NOT NULL,
    module_id integer,
    link_type text,
    link_array text,
    link_file text,
    weight integer,
    disabled boolean
);


ALTER TABLE public.core_base_module_links OWNER TO dbadmin;

--
-- TOC entry 185 (class 1259 OID 159468)
-- Dependencies: 6 186
-- Name: core_base_module_links_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_module_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_module_links_id_seq OWNER TO dbadmin;

--
-- TOC entry 3230 (class 0 OID 0)
-- Dependencies: 185
-- Name: core_base_module_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_module_links_id_seq OWNED BY core_base_module_links.id;


--
-- TOC entry 3231 (class 0 OID 0)
-- Dependencies: 185
-- Name: core_base_module_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_module_links_id_seq', 9, true);


--
-- TOC entry 188 (class 1259 OID 159481)
-- Dependencies: 6
-- Name: core_base_module_navigation; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_module_navigation (
    id integer NOT NULL,
    language_address text,
    "position" integer,
    colour text,
    module_id integer,
    hidden boolean,
    alias text,
    controller_class text,
    controller_file text
);


ALTER TABLE public.core_base_module_navigation OWNER TO dbadmin;

--
-- TOC entry 187 (class 1259 OID 159479)
-- Dependencies: 188 6
-- Name: core_base_module_navigation_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_module_navigation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_module_navigation_id_seq OWNER TO dbadmin;

--
-- TOC entry 3232 (class 0 OID 0)
-- Dependencies: 187
-- Name: core_base_module_navigation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_module_navigation_id_seq OWNED BY core_base_module_navigation.id;


--
-- TOC entry 3233 (class 0 OID 0)
-- Dependencies: 187
-- Name: core_base_module_navigation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_module_navigation_id_seq', 7, true);


--
-- TOC entry 190 (class 1259 OID 159494)
-- Dependencies: 6
-- Name: core_base_modules; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_modules (
    id integer NOT NULL,
    name text,
    folder text,
    class text,
    disabled boolean
);


ALTER TABLE public.core_base_modules OWNER TO dbadmin;

--
-- TOC entry 189 (class 1259 OID 159492)
-- Dependencies: 190 6
-- Name: core_base_modules_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_modules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_modules_id_seq OWNER TO dbadmin;

--
-- TOC entry 3234 (class 0 OID 0)
-- Dependencies: 189
-- Name: core_base_modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_modules_id_seq OWNED BY core_base_modules.id;


--
-- TOC entry 3235 (class 0 OID 0)
-- Dependencies: 189
-- Name: core_base_modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_modules_id_seq', 10, true);


--
-- TOC entry 192 (class 1259 OID 159505)
-- Dependencies: 6
-- Name: core_base_registry; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_base_registry (
    id integer NOT NULL,
    name text,
    include_id integer,
    value text
);


ALTER TABLE public.core_base_registry OWNER TO dbadmin;

--
-- TOC entry 191 (class 1259 OID 159503)
-- Dependencies: 6 192
-- Name: core_base_registry_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_base_registry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_base_registry_id_seq OWNER TO dbadmin;

--
-- TOC entry 3236 (class 0 OID 0)
-- Dependencies: 191
-- Name: core_base_registry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_base_registry_id_seq OWNED BY core_base_registry.id;


--
-- TOC entry 3237 (class 0 OID 0)
-- Dependencies: 191
-- Name: core_base_registry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_base_registry_id_seq', 26, true);


--
-- TOC entry 194 (class 1259 OID 159518)
-- Dependencies: 6
-- Name: core_binaries; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_binaries (
    id integer NOT NULL,
    path text,
    file text
);


ALTER TABLE public.core_binaries OWNER TO dbadmin;

--
-- TOC entry 193 (class 1259 OID 159516)
-- Dependencies: 6 194
-- Name: core_binaries_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_binaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_binaries_id_seq OWNER TO dbadmin;

--
-- TOC entry 3238 (class 0 OID 0)
-- Dependencies: 193
-- Name: core_binaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_binaries_id_seq OWNED BY core_binaries.id;


--
-- TOC entry 3239 (class 0 OID 0)
-- Dependencies: 193
-- Name: core_binaries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_binaries_id_seq', 1, false);


--
-- TOC entry 196 (class 1259 OID 159529)
-- Dependencies: 6
-- Name: core_countries; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_countries (
    id integer NOT NULL,
    english_name text,
    local_name text,
    iso_3166 text
);


ALTER TABLE public.core_countries OWNER TO dbadmin;

--
-- TOC entry 195 (class 1259 OID 159527)
-- Dependencies: 6 196
-- Name: core_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_countries_id_seq OWNER TO dbadmin;

--
-- TOC entry 3240 (class 0 OID 0)
-- Dependencies: 195
-- Name: core_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_countries_id_seq OWNED BY core_countries.id;


--
-- TOC entry 3241 (class 0 OID 0)
-- Dependencies: 195
-- Name: core_countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_countries_id_seq', 198, true);


--
-- TOC entry 198 (class 1259 OID 159540)
-- Dependencies: 6
-- Name: core_currencies; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_currencies (
    id integer NOT NULL,
    name text,
    symbol text,
    iso_4217 text
);


ALTER TABLE public.core_currencies OWNER TO dbadmin;

--
-- TOC entry 197 (class 1259 OID 159538)
-- Dependencies: 198 6
-- Name: core_currencies_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_currencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_currencies_id_seq OWNER TO dbadmin;

--
-- TOC entry 3242 (class 0 OID 0)
-- Dependencies: 197
-- Name: core_currencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_currencies_id_seq OWNED BY core_currencies.id;


--
-- TOC entry 3243 (class 0 OID 0)
-- Dependencies: 197
-- Name: core_currencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_currencies_id_seq', 2, true);


--
-- TOC entry 262 (class 1259 OID 160156)
-- Dependencies: 6
-- Name: core_data_entities; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_entities (
    id integer NOT NULL,
    datetime timestamp with time zone,
    owner_id integer,
    owner_group_id integer,
    permission integer,
    automatic boolean
);


ALTER TABLE public.core_data_entities OWNER TO dbadmin;

--
-- TOC entry 261 (class 1259 OID 160154)
-- Dependencies: 262 6
-- Name: core_data_entities_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_entities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_entities_id_seq OWNER TO dbadmin;

--
-- TOC entry 3244 (class 0 OID 0)
-- Dependencies: 261
-- Name: core_data_entities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_entities_id_seq OWNED BY core_data_entities.id;


--
-- TOC entry 3245 (class 0 OID 0)
-- Dependencies: 261
-- Name: core_data_entities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_entities_id_seq', 10015, true);


--
-- TOC entry 263 (class 1259 OID 160162)
-- Dependencies: 6
-- Name: core_data_entity_has_data_entities; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_entity_has_data_entities (
    data_entity_pid integer NOT NULL,
    data_entity_cid integer NOT NULL,
    link boolean,
    link_item_id integer
);


ALTER TABLE public.core_data_entity_has_data_entities OWNER TO dbadmin;

--
-- TOC entry 264 (class 1259 OID 160167)
-- Dependencies: 6
-- Name: core_data_entity_is_item; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_entity_is_item (
    data_entity_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.core_data_entity_is_item OWNER TO dbadmin;

--
-- TOC entry 265 (class 1259 OID 160174)
-- Dependencies: 6
-- Name: core_data_parameter_field_has_methods; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_field_has_methods (
    parameter_field_id integer NOT NULL,
    parameter_method_id integer NOT NULL
);


ALTER TABLE public.core_data_parameter_field_has_methods OWNER TO dbadmin;

--
-- TOC entry 266 (class 1259 OID 160179)
-- Dependencies: 6
-- Name: core_data_parameter_field_limits; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_field_limits (
    parameter_limit_id integer NOT NULL,
    parameter_field_id integer NOT NULL,
    upper_specification_limit double precision,
    lower_specification_limit double precision
);


ALTER TABLE public.core_data_parameter_field_limits OWNER TO dbadmin;

--
-- TOC entry 268 (class 1259 OID 160186)
-- Dependencies: 6
-- Name: core_data_parameter_field_values; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_field_values (
    id integer NOT NULL,
    parameter_version_id integer,
    parameter_field_id integer,
    parameter_method_id integer,
    value double precision,
    source text,
    locked boolean
);


ALTER TABLE public.core_data_parameter_field_values OWNER TO dbadmin;

--
-- TOC entry 267 (class 1259 OID 160184)
-- Dependencies: 268 6
-- Name: core_data_parameter_field_values_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameter_field_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameter_field_values_id_seq OWNER TO dbadmin;

--
-- TOC entry 3246 (class 0 OID 0)
-- Dependencies: 267
-- Name: core_data_parameter_field_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameter_field_values_id_seq OWNED BY core_data_parameter_field_values.id;


--
-- TOC entry 3247 (class 0 OID 0)
-- Dependencies: 267
-- Name: core_data_parameter_field_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameter_field_values_id_seq', 1, false);


--
-- TOC entry 270 (class 1259 OID 160197)
-- Dependencies: 6
-- Name: core_data_parameter_fields; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_fields (
    id integer NOT NULL,
    name text,
    min_value double precision,
    max_value double precision,
    measuring_unit_id integer,
    measuring_unit_exponent integer,
    measuring_unit_ratio_id integer
);


ALTER TABLE public.core_data_parameter_fields OWNER TO dbadmin;

--
-- TOC entry 269 (class 1259 OID 160195)
-- Dependencies: 6 270
-- Name: core_data_parameter_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameter_fields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameter_fields_id_seq OWNER TO dbadmin;

--
-- TOC entry 3248 (class 0 OID 0)
-- Dependencies: 269
-- Name: core_data_parameter_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameter_fields_id_seq OWNED BY core_data_parameter_fields.id;


--
-- TOC entry 3249 (class 0 OID 0)
-- Dependencies: 269
-- Name: core_data_parameter_fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameter_fields_id_seq', 21, true);


--
-- TOC entry 271 (class 1259 OID 160206)
-- Dependencies: 6
-- Name: core_data_parameter_has_non_template; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_has_non_template (
    parameter_id integer NOT NULL,
    non_template_id integer NOT NULL
);


ALTER TABLE public.core_data_parameter_has_non_template OWNER TO dbadmin;

--
-- TOC entry 272 (class 1259 OID 160213)
-- Dependencies: 6
-- Name: core_data_parameter_has_template; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_has_template (
    parameter_id integer NOT NULL,
    template_id integer NOT NULL
);


ALTER TABLE public.core_data_parameter_has_template OWNER TO dbadmin;

--
-- TOC entry 274 (class 1259 OID 160222)
-- Dependencies: 6
-- Name: core_data_parameter_limits; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_limits (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.core_data_parameter_limits OWNER TO dbadmin;

--
-- TOC entry 273 (class 1259 OID 160220)
-- Dependencies: 6 274
-- Name: core_data_parameter_limits_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameter_limits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameter_limits_id_seq OWNER TO dbadmin;

--
-- TOC entry 3250 (class 0 OID 0)
-- Dependencies: 273
-- Name: core_data_parameter_limits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameter_limits_id_seq OWNED BY core_data_parameter_limits.id;


--
-- TOC entry 3251 (class 0 OID 0)
-- Dependencies: 273
-- Name: core_data_parameter_limits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameter_limits_id_seq', 3, true);


--
-- TOC entry 276 (class 1259 OID 160233)
-- Dependencies: 6
-- Name: core_data_parameter_methods; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_methods (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.core_data_parameter_methods OWNER TO dbadmin;

--
-- TOC entry 275 (class 1259 OID 160231)
-- Dependencies: 276 6
-- Name: core_data_parameter_methods_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameter_methods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameter_methods_id_seq OWNER TO dbadmin;

--
-- TOC entry 3252 (class 0 OID 0)
-- Dependencies: 275
-- Name: core_data_parameter_methods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameter_methods_id_seq OWNED BY core_data_parameter_methods.id;


--
-- TOC entry 3253 (class 0 OID 0)
-- Dependencies: 275
-- Name: core_data_parameter_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameter_methods_id_seq', 3, true);


--
-- TOC entry 277 (class 1259 OID 160242)
-- Dependencies: 6
-- Name: core_data_parameter_non_template_has_fields; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_non_template_has_fields (
    non_template_id integer NOT NULL,
    parameter_field_id integer NOT NULL
);


ALTER TABLE public.core_data_parameter_non_template_has_fields OWNER TO dbadmin;

--
-- TOC entry 279 (class 1259 OID 160249)
-- Dependencies: 6
-- Name: core_data_parameter_non_templates; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_non_templates (
    id integer NOT NULL,
    datetime timestamp with time zone
);


ALTER TABLE public.core_data_parameter_non_templates OWNER TO dbadmin;

--
-- TOC entry 278 (class 1259 OID 160247)
-- Dependencies: 279 6
-- Name: core_data_parameter_non_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameter_non_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameter_non_templates_id_seq OWNER TO dbadmin;

--
-- TOC entry 3254 (class 0 OID 0)
-- Dependencies: 278
-- Name: core_data_parameter_non_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameter_non_templates_id_seq OWNED BY core_data_parameter_non_templates.id;


--
-- TOC entry 3255 (class 0 OID 0)
-- Dependencies: 278
-- Name: core_data_parameter_non_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameter_non_templates_id_seq', 1, false);


--
-- TOC entry 280 (class 1259 OID 160255)
-- Dependencies: 6
-- Name: core_data_parameter_template_has_fields; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_template_has_fields (
    template_id integer NOT NULL,
    parameter_field_id integer NOT NULL,
    "position" integer
);


ALTER TABLE public.core_data_parameter_template_has_fields OWNER TO dbadmin;

--
-- TOC entry 282 (class 1259 OID 160262)
-- Dependencies: 6
-- Name: core_data_parameter_templates; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_templates (
    id integer NOT NULL,
    internal_name text,
    name text,
    created_by integer,
    datetime timestamp with time zone
);


ALTER TABLE public.core_data_parameter_templates OWNER TO dbadmin;

--
-- TOC entry 281 (class 1259 OID 160260)
-- Dependencies: 282 6
-- Name: core_data_parameter_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameter_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameter_templates_id_seq OWNER TO dbadmin;

--
-- TOC entry 3256 (class 0 OID 0)
-- Dependencies: 281
-- Name: core_data_parameter_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameter_templates_id_seq OWNED BY core_data_parameter_templates.id;


--
-- TOC entry 3257 (class 0 OID 0)
-- Dependencies: 281
-- Name: core_data_parameter_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameter_templates_id_seq', 3, true);


--
-- TOC entry 284 (class 1259 OID 160275)
-- Dependencies: 6
-- Name: core_data_parameter_versions; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameter_versions (
    id integer NOT NULL,
    parameter_id integer,
    version integer,
    internal_revision integer,
    previous_version_id integer,
    current boolean,
    owner_id integer,
    datetime timestamp with time zone,
    name text,
    parameter_limit_id integer
);


ALTER TABLE public.core_data_parameter_versions OWNER TO dbadmin;

--
-- TOC entry 283 (class 1259 OID 160273)
-- Dependencies: 284 6
-- Name: core_data_parameter_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameter_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameter_versions_id_seq OWNER TO dbadmin;

--
-- TOC entry 3258 (class 0 OID 0)
-- Dependencies: 283
-- Name: core_data_parameter_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameter_versions_id_seq OWNED BY core_data_parameter_versions.id;


--
-- TOC entry 3259 (class 0 OID 0)
-- Dependencies: 283
-- Name: core_data_parameter_versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameter_versions_id_seq', 1, false);


--
-- TOC entry 286 (class 1259 OID 160286)
-- Dependencies: 6
-- Name: core_data_parameters; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_parameters (
    id integer NOT NULL,
    data_entity_id integer
);


ALTER TABLE public.core_data_parameters OWNER TO dbadmin;

--
-- TOC entry 285 (class 1259 OID 160284)
-- Dependencies: 6 286
-- Name: core_data_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_data_parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_data_parameters_id_seq OWNER TO dbadmin;

--
-- TOC entry 3260 (class 0 OID 0)
-- Dependencies: 285
-- Name: core_data_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_data_parameters_id_seq OWNED BY core_data_parameters.id;


--
-- TOC entry 3261 (class 0 OID 0)
-- Dependencies: 285
-- Name: core_data_parameters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_data_parameters_id_seq', 1, false);


--
-- TOC entry 287 (class 1259 OID 160292)
-- Dependencies: 6
-- Name: core_data_user_data; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_data_user_data (
    user_id integer NOT NULL,
    quota bigint,
    filesize bigint
);


ALTER TABLE public.core_data_user_data OWNER TO dbadmin;

--
-- TOC entry 369 (class 1259 OID 161354)
-- Dependencies: 6
-- Name: core_equipment; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_equipment (
    id integer NOT NULL,
    type_id integer,
    owner_id integer,
    datetime timestamp with time zone
);


ALTER TABLE public.core_equipment OWNER TO dbadmin;

--
-- TOC entry 371 (class 1259 OID 161362)
-- Dependencies: 6
-- Name: core_equipment_cats; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_equipment_cats (
    id integer NOT NULL,
    toid integer,
    name text
);


ALTER TABLE public.core_equipment_cats OWNER TO dbadmin;

--
-- TOC entry 370 (class 1259 OID 161360)
-- Dependencies: 371 6
-- Name: core_equipment_cats_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_equipment_cats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_equipment_cats_id_seq OWNER TO dbadmin;

--
-- TOC entry 3262 (class 0 OID 0)
-- Dependencies: 370
-- Name: core_equipment_cats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_equipment_cats_id_seq OWNED BY core_equipment_cats.id;


--
-- TOC entry 3263 (class 0 OID 0)
-- Dependencies: 370
-- Name: core_equipment_cats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_equipment_cats_id_seq', 100000, true);


--
-- TOC entry 372 (class 1259 OID 161371)
-- Dependencies: 6
-- Name: core_equipment_has_organisation_units; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_equipment_has_organisation_units (
    equipment_id integer NOT NULL,
    organisation_unit_id integer NOT NULL
);


ALTER TABLE public.core_equipment_has_organisation_units OWNER TO dbadmin;

--
-- TOC entry 373 (class 1259 OID 161376)
-- Dependencies: 6
-- Name: core_equipment_has_responsible_persons; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_equipment_has_responsible_persons (
    equipment_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.core_equipment_has_responsible_persons OWNER TO dbadmin;

--
-- TOC entry 368 (class 1259 OID 161352)
-- Dependencies: 369 6
-- Name: core_equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_equipment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_equipment_id_seq OWNER TO dbadmin;

--
-- TOC entry 3264 (class 0 OID 0)
-- Dependencies: 368
-- Name: core_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_equipment_id_seq OWNED BY core_equipment.id;


--
-- TOC entry 3265 (class 0 OID 0)
-- Dependencies: 368
-- Name: core_equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_equipment_id_seq', 1, false);


--
-- TOC entry 374 (class 1259 OID 161381)
-- Dependencies: 6
-- Name: core_equipment_is_item; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_equipment_is_item (
    equipment_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.core_equipment_is_item OWNER TO dbadmin;

--
-- TOC entry 376 (class 1259 OID 161390)
-- Dependencies: 6
-- Name: core_equipment_types; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_equipment_types (
    id integer NOT NULL,
    toid integer,
    name text,
    cat_id integer,
    location_id integer,
    description text,
    manufacturer text
);


ALTER TABLE public.core_equipment_types OWNER TO dbadmin;

--
-- TOC entry 375 (class 1259 OID 161388)
-- Dependencies: 376 6
-- Name: core_equipment_types_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_equipment_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_equipment_types_id_seq OWNER TO dbadmin;

--
-- TOC entry 3266 (class 0 OID 0)
-- Dependencies: 375
-- Name: core_equipment_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_equipment_types_id_seq OWNED BY core_equipment_types.id;


--
-- TOC entry 3267 (class 0 OID 0)
-- Dependencies: 375
-- Name: core_equipment_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_equipment_types_id_seq', 999999000, true);


--
-- TOC entry 200 (class 1259 OID 159551)
-- Dependencies: 6
-- Name: core_extensions; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_extensions (
    id integer NOT NULL,
    name text,
    identifier text,
    folder text,
    class text,
    main_file text,
    version text
);


ALTER TABLE public.core_extensions OWNER TO dbadmin;

--
-- TOC entry 199 (class 1259 OID 159549)
-- Dependencies: 6 200
-- Name: core_extensions_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_extensions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_extensions_id_seq OWNER TO dbadmin;

--
-- TOC entry 3268 (class 0 OID 0)
-- Dependencies: 199
-- Name: core_extensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_extensions_id_seq OWNED BY core_extensions.id;


--
-- TOC entry 3269 (class 0 OID 0)
-- Dependencies: 199
-- Name: core_extensions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_extensions_id_seq', 1, false);


--
-- TOC entry 289 (class 1259 OID 160299)
-- Dependencies: 6
-- Name: core_file_image_cache; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_file_image_cache (
    id integer NOT NULL,
    file_version_id integer,
    width integer,
    height integer,
    size bigint,
    last_access timestamp with time zone
);


ALTER TABLE public.core_file_image_cache OWNER TO dbadmin;

--
-- TOC entry 288 (class 1259 OID 160297)
-- Dependencies: 289 6
-- Name: core_file_image_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_file_image_cache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_file_image_cache_id_seq OWNER TO dbadmin;

--
-- TOC entry 3270 (class 0 OID 0)
-- Dependencies: 288
-- Name: core_file_image_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_file_image_cache_id_seq OWNED BY core_file_image_cache.id;


--
-- TOC entry 3271 (class 0 OID 0)
-- Dependencies: 288
-- Name: core_file_image_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_file_image_cache_id_seq', 1, false);


--
-- TOC entry 290 (class 1259 OID 160305)
-- Dependencies: 6
-- Name: core_file_version_blobs; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_file_version_blobs (
    file_version_id integer NOT NULL,
    blob bytea
);


ALTER TABLE public.core_file_version_blobs OWNER TO dbadmin;

--
-- TOC entry 292 (class 1259 OID 160315)
-- Dependencies: 6
-- Name: core_file_versions; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_file_versions (
    id integer NOT NULL,
    toid integer,
    name text,
    version integer,
    size bigint,
    checksum character(32),
    datetime timestamp with time zone,
    comment text,
    previous_version_id integer,
    internal_revision integer,
    current boolean,
    file_extension text,
    owner_id integer
);


ALTER TABLE public.core_file_versions OWNER TO dbadmin;

--
-- TOC entry 291 (class 1259 OID 160313)
-- Dependencies: 292 6
-- Name: core_file_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_file_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_file_versions_id_seq OWNER TO dbadmin;

--
-- TOC entry 3272 (class 0 OID 0)
-- Dependencies: 291
-- Name: core_file_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_file_versions_id_seq OWNED BY core_file_versions.id;


--
-- TOC entry 3273 (class 0 OID 0)
-- Dependencies: 291
-- Name: core_file_versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_file_versions_id_seq', 1, false);


--
-- TOC entry 294 (class 1259 OID 160328)
-- Dependencies: 6
-- Name: core_files; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_files (
    id integer NOT NULL,
    data_entity_id integer,
    flag integer
);


ALTER TABLE public.core_files OWNER TO dbadmin;

--
-- TOC entry 293 (class 1259 OID 160326)
-- Dependencies: 6 294
-- Name: core_files_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_files_id_seq OWNER TO dbadmin;

--
-- TOC entry 3274 (class 0 OID 0)
-- Dependencies: 293
-- Name: core_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_files_id_seq OWNED BY core_files.id;


--
-- TOC entry 3275 (class 0 OID 0)
-- Dependencies: 293
-- Name: core_files_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_files_id_seq', 1, false);


--
-- TOC entry 296 (class 1259 OID 160336)
-- Dependencies: 6
-- Name: core_folder_concretion; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_folder_concretion (
    id integer NOT NULL,
    type text,
    handling_class text,
    include_id integer
);


ALTER TABLE public.core_folder_concretion OWNER TO dbadmin;

--
-- TOC entry 295 (class 1259 OID 160334)
-- Dependencies: 296 6
-- Name: core_folder_concretion_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_folder_concretion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_folder_concretion_id_seq OWNER TO dbadmin;

--
-- TOC entry 3276 (class 0 OID 0)
-- Dependencies: 295
-- Name: core_folder_concretion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_folder_concretion_id_seq OWNED BY core_folder_concretion.id;


--
-- TOC entry 3277 (class 0 OID 0)
-- Dependencies: 295
-- Name: core_folder_concretion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_folder_concretion_id_seq', 7, true);


--
-- TOC entry 297 (class 1259 OID 160345)
-- Dependencies: 6
-- Name: core_folder_is_group_folder; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_folder_is_group_folder (
    group_id integer NOT NULL,
    folder_id integer NOT NULL
);


ALTER TABLE public.core_folder_is_group_folder OWNER TO dbadmin;

--
-- TOC entry 298 (class 1259 OID 160350)
-- Dependencies: 6
-- Name: core_folder_is_organisation_unit_folder; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_folder_is_organisation_unit_folder (
    organisation_unit_id integer NOT NULL,
    folder_id integer NOT NULL
);


ALTER TABLE public.core_folder_is_organisation_unit_folder OWNER TO dbadmin;

--
-- TOC entry 299 (class 1259 OID 160355)
-- Dependencies: 6
-- Name: core_folder_is_system_folder; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_folder_is_system_folder (
    folder_id integer NOT NULL
);


ALTER TABLE public.core_folder_is_system_folder OWNER TO dbadmin;

--
-- TOC entry 300 (class 1259 OID 160360)
-- Dependencies: 6
-- Name: core_folder_is_user_folder; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_folder_is_user_folder (
    user_id integer NOT NULL,
    folder_id integer NOT NULL
);


ALTER TABLE public.core_folder_is_user_folder OWNER TO dbadmin;

--
-- TOC entry 302 (class 1259 OID 160367)
-- Dependencies: 6
-- Name: core_folders; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_folders (
    id integer NOT NULL,
    data_entity_id integer,
    name text,
    path text,
    deleted boolean,
    blob boolean,
    flag integer
);


ALTER TABLE public.core_folders OWNER TO dbadmin;

--
-- TOC entry 301 (class 1259 OID 160365)
-- Dependencies: 6 302
-- Name: core_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_folders_id_seq OWNER TO dbadmin;

--
-- TOC entry 3278 (class 0 OID 0)
-- Dependencies: 301
-- Name: core_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_folders_id_seq OWNED BY core_folders.id;


--
-- TOC entry 3279 (class 0 OID 0)
-- Dependencies: 301
-- Name: core_folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_folders_id_seq', 10003, true);


--
-- TOC entry 202 (class 1259 OID 159564)
-- Dependencies: 6
-- Name: core_group_has_users; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_group_has_users (
    primary_key integer NOT NULL,
    group_id integer,
    user_id integer
);


ALTER TABLE public.core_group_has_users OWNER TO dbadmin;

--
-- TOC entry 201 (class 1259 OID 159562)
-- Dependencies: 202 6
-- Name: core_group_has_users_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_group_has_users_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_group_has_users_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3280 (class 0 OID 0)
-- Dependencies: 201
-- Name: core_group_has_users_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_group_has_users_primary_key_seq OWNED BY core_group_has_users.primary_key;


--
-- TOC entry 3281 (class 0 OID 0)
-- Dependencies: 201
-- Name: core_group_has_users_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_group_has_users_primary_key_seq', 2, true);


--
-- TOC entry 204 (class 1259 OID 159572)
-- Dependencies: 6
-- Name: core_groups; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_groups (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.core_groups OWNER TO dbadmin;

--
-- TOC entry 203 (class 1259 OID 159570)
-- Dependencies: 204 6
-- Name: core_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_groups_id_seq OWNER TO dbadmin;

--
-- TOC entry 3282 (class 0 OID 0)
-- Dependencies: 203
-- Name: core_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_groups_id_seq OWNED BY core_groups.id;


--
-- TOC entry 3283 (class 0 OID 0)
-- Dependencies: 203
-- Name: core_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_groups_id_seq', 100, true);


--
-- TOC entry 238 (class 1259 OID 159995)
-- Dependencies: 6
-- Name: core_item_class_has_item_information; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_item_class_has_item_information (
    primary_key integer NOT NULL,
    item_class_id integer,
    item_information_id integer
);


ALTER TABLE public.core_item_class_has_item_information OWNER TO dbadmin;

--
-- TOC entry 237 (class 1259 OID 159993)
-- Dependencies: 238 6
-- Name: core_item_class_has_item_information_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_item_class_has_item_information_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_item_class_has_item_information_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3284 (class 0 OID 0)
-- Dependencies: 237
-- Name: core_item_class_has_item_information_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_item_class_has_item_information_primary_key_seq OWNED BY core_item_class_has_item_information.primary_key;


--
-- TOC entry 3285 (class 0 OID 0)
-- Dependencies: 237
-- Name: core_item_class_has_item_information_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_item_class_has_item_information_primary_key_seq', 1, false);


--
-- TOC entry 240 (class 1259 OID 160003)
-- Dependencies: 6
-- Name: core_item_classes; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_item_classes (
    id integer NOT NULL,
    name text,
    datetime timestamp with time zone,
    owner_id integer,
    colour character(6)
);


ALTER TABLE public.core_item_classes OWNER TO dbadmin;

--
-- TOC entry 239 (class 1259 OID 160001)
-- Dependencies: 6 240
-- Name: core_item_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_item_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_item_classes_id_seq OWNER TO dbadmin;

--
-- TOC entry 3286 (class 0 OID 0)
-- Dependencies: 239
-- Name: core_item_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_item_classes_id_seq OWNED BY core_item_classes.id;


--
-- TOC entry 3287 (class 0 OID 0)
-- Dependencies: 239
-- Name: core_item_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_item_classes_id_seq', 1, false);


--
-- TOC entry 242 (class 1259 OID 160014)
-- Dependencies: 6
-- Name: core_item_concretion; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_item_concretion (
    id integer NOT NULL,
    type text,
    handling_class text,
    include_id integer
);


ALTER TABLE public.core_item_concretion OWNER TO dbadmin;

--
-- TOC entry 241 (class 1259 OID 160012)
-- Dependencies: 242 6
-- Name: core_item_concretion_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_item_concretion_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_item_concretion_id_seq OWNER TO dbadmin;

--
-- TOC entry 3288 (class 0 OID 0)
-- Dependencies: 241
-- Name: core_item_concretion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_item_concretion_id_seq OWNED BY core_item_concretion.id;


--
-- TOC entry 3289 (class 0 OID 0)
-- Dependencies: 241
-- Name: core_item_concretion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_item_concretion_id_seq', 6, true);


--
-- TOC entry 244 (class 1259 OID 160025)
-- Dependencies: 6
-- Name: core_item_has_item_classes; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_item_has_item_classes (
    primary_key integer NOT NULL,
    item_id integer,
    item_class_id integer
);


ALTER TABLE public.core_item_has_item_classes OWNER TO dbadmin;

--
-- TOC entry 243 (class 1259 OID 160023)
-- Dependencies: 6 244
-- Name: core_item_has_item_classes_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_item_has_item_classes_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_item_has_item_classes_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3290 (class 0 OID 0)
-- Dependencies: 243
-- Name: core_item_has_item_classes_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_item_has_item_classes_primary_key_seq OWNED BY core_item_has_item_classes.primary_key;


--
-- TOC entry 3291 (class 0 OID 0)
-- Dependencies: 243
-- Name: core_item_has_item_classes_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_item_has_item_classes_primary_key_seq', 1, false);


--
-- TOC entry 246 (class 1259 OID 160033)
-- Dependencies: 6
-- Name: core_item_has_item_information; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_item_has_item_information (
    primary_key integer NOT NULL,
    item_id integer,
    item_information_id integer
);


ALTER TABLE public.core_item_has_item_information OWNER TO dbadmin;

--
-- TOC entry 245 (class 1259 OID 160031)
-- Dependencies: 246 6
-- Name: core_item_has_item_information_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_item_has_item_information_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_item_has_item_information_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3292 (class 0 OID 0)
-- Dependencies: 245
-- Name: core_item_has_item_information_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_item_has_item_information_primary_key_seq OWNED BY core_item_has_item_information.primary_key;


--
-- TOC entry 3293 (class 0 OID 0)
-- Dependencies: 245
-- Name: core_item_has_item_information_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_item_has_item_information_primary_key_seq', 1, false);


--
-- TOC entry 248 (class 1259 OID 160041)
-- Dependencies: 6
-- Name: core_item_holders; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_item_holders (
    id integer NOT NULL,
    name text,
    handling_class text,
    include_id integer
);


ALTER TABLE public.core_item_holders OWNER TO dbadmin;

--
-- TOC entry 247 (class 1259 OID 160039)
-- Dependencies: 248 6
-- Name: core_item_holders_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_item_holders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_item_holders_id_seq OWNER TO dbadmin;

--
-- TOC entry 3294 (class 0 OID 0)
-- Dependencies: 247
-- Name: core_item_holders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_item_holders_id_seq OWNED BY core_item_holders.id;


--
-- TOC entry 3295 (class 0 OID 0)
-- Dependencies: 247
-- Name: core_item_holders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_item_holders_id_seq', 2, true);


--
-- TOC entry 250 (class 1259 OID 160052)
-- Dependencies: 6
-- Name: core_item_information; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_item_information (
    id integer NOT NULL,
    description text,
    keywords text,
    last_update timestamp with time zone,
    description_text_search_vector tsvector,
    keywords_text_search_vector tsvector,
    language_id integer
);


ALTER TABLE public.core_item_information OWNER TO dbadmin;

--
-- TOC entry 249 (class 1259 OID 160050)
-- Dependencies: 250 6
-- Name: core_item_information_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_item_information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_item_information_id_seq OWNER TO dbadmin;

--
-- TOC entry 3296 (class 0 OID 0)
-- Dependencies: 249
-- Name: core_item_information_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_item_information_id_seq OWNED BY core_item_information.id;


--
-- TOC entry 3297 (class 0 OID 0)
-- Dependencies: 249
-- Name: core_item_information_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_item_information_id_seq', 1, false);


--
-- TOC entry 252 (class 1259 OID 160063)
-- Dependencies: 6
-- Name: core_items; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_items (
    id integer NOT NULL,
    datetime timestamp with time zone
);


ALTER TABLE public.core_items OWNER TO dbadmin;

--
-- TOC entry 251 (class 1259 OID 160061)
-- Dependencies: 6 252
-- Name: core_items_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_items_id_seq OWNER TO dbadmin;

--
-- TOC entry 3298 (class 0 OID 0)
-- Dependencies: 251
-- Name: core_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_items_id_seq OWNED BY core_items.id;


--
-- TOC entry 3299 (class 0 OID 0)
-- Dependencies: 251
-- Name: core_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_items_id_seq', 10015, true);


--
-- TOC entry 206 (class 1259 OID 159583)
-- Dependencies: 6
-- Name: core_languages; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_languages (
    id integer NOT NULL,
    english_name text,
    language_name text,
    tsvector_name text,
    iso_639 character(2),
    iso_3166 character(2)
);


ALTER TABLE public.core_languages OWNER TO dbadmin;

--
-- TOC entry 205 (class 1259 OID 159581)
-- Dependencies: 6 206
-- Name: core_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_languages_id_seq OWNER TO dbadmin;

--
-- TOC entry 3300 (class 0 OID 0)
-- Dependencies: 205
-- Name: core_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_languages_id_seq OWNED BY core_languages.id;


--
-- TOC entry 3301 (class 0 OID 0)
-- Dependencies: 205
-- Name: core_languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_languages_id_seq', 2, true);


--
-- TOC entry 314 (class 1259 OID 160731)
-- Dependencies: 6
-- Name: core_location_types; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_location_types (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.core_location_types OWNER TO dbadmin;

--
-- TOC entry 313 (class 1259 OID 160729)
-- Dependencies: 6 314
-- Name: core_location_types_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_location_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_location_types_id_seq OWNER TO dbadmin;

--
-- TOC entry 3302 (class 0 OID 0)
-- Dependencies: 313
-- Name: core_location_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_location_types_id_seq OWNED BY core_location_types.id;


--
-- TOC entry 3303 (class 0 OID 0)
-- Dependencies: 313
-- Name: core_location_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_location_types_id_seq', 9, true);


--
-- TOC entry 316 (class 1259 OID 160742)
-- Dependencies: 6
-- Name: core_locations; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_locations (
    id integer NOT NULL,
    toid integer,
    type_id integer,
    name text,
    additional_name text,
    prefix boolean
);


ALTER TABLE public.core_locations OWNER TO dbadmin;

--
-- TOC entry 315 (class 1259 OID 160740)
-- Dependencies: 6 316
-- Name: core_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_locations_id_seq OWNER TO dbadmin;

--
-- TOC entry 3304 (class 0 OID 0)
-- Dependencies: 315
-- Name: core_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_locations_id_seq OWNED BY core_locations.id;


--
-- TOC entry 3305 (class 0 OID 0)
-- Dependencies: 315
-- Name: core_locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_locations_id_seq', 1, false);


--
-- TOC entry 318 (class 1259 OID 160763)
-- Dependencies: 6
-- Name: core_manufacturers; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_manufacturers (
    id integer NOT NULL,
    name text,
    user_id integer,
    datetime timestamp with time zone
);


ALTER TABLE public.core_manufacturers OWNER TO dbadmin;

--
-- TOC entry 317 (class 1259 OID 160761)
-- Dependencies: 318 6
-- Name: core_manufacturers_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_manufacturers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_manufacturers_id_seq OWNER TO dbadmin;

--
-- TOC entry 3306 (class 0 OID 0)
-- Dependencies: 317
-- Name: core_manufacturers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_manufacturers_id_seq OWNED BY core_manufacturers.id;


--
-- TOC entry 3307 (class 0 OID 0)
-- Dependencies: 317
-- Name: core_manufacturers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_manufacturers_id_seq', 1, false);


--
-- TOC entry 254 (class 1259 OID 160118)
-- Dependencies: 6
-- Name: core_oldl_templates; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_oldl_templates (
    id integer NOT NULL,
    data_entity_id integer
);


ALTER TABLE public.core_oldl_templates OWNER TO dbadmin;

--
-- TOC entry 253 (class 1259 OID 160116)
-- Dependencies: 6 254
-- Name: core_oldl_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_oldl_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_oldl_templates_id_seq OWNER TO dbadmin;

--
-- TOC entry 3308 (class 0 OID 0)
-- Dependencies: 253
-- Name: core_oldl_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_oldl_templates_id_seq OWNED BY core_oldl_templates.id;


--
-- TOC entry 3309 (class 0 OID 0)
-- Dependencies: 253
-- Name: core_oldl_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_oldl_templates_id_seq', 1, false);


--
-- TOC entry 256 (class 1259 OID 160126)
-- Dependencies: 6
-- Name: core_olvdl_templates; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_olvdl_templates (
    id integer NOT NULL,
    data_entity_id integer
);


ALTER TABLE public.core_olvdl_templates OWNER TO dbadmin;

--
-- TOC entry 255 (class 1259 OID 160124)
-- Dependencies: 6 256
-- Name: core_olvdl_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_olvdl_templates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_olvdl_templates_id_seq OWNER TO dbadmin;

--
-- TOC entry 3310 (class 0 OID 0)
-- Dependencies: 255
-- Name: core_olvdl_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_olvdl_templates_id_seq OWNED BY core_olvdl_templates.id;


--
-- TOC entry 3311 (class 0 OID 0)
-- Dependencies: 255
-- Name: core_olvdl_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_olvdl_templates_id_seq', 1, false);


--
-- TOC entry 236 (class 1259 OID 159926)
-- Dependencies: 6
-- Name: core_organisation_unit_has_groups; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_organisation_unit_has_groups (
    organisation_unit_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.core_organisation_unit_has_groups OWNER TO dbadmin;

--
-- TOC entry 235 (class 1259 OID 159921)
-- Dependencies: 6
-- Name: core_organisation_unit_has_leaders; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_organisation_unit_has_leaders (
    organisation_unit_id integer NOT NULL,
    leader_id integer NOT NULL
);


ALTER TABLE public.core_organisation_unit_has_leaders OWNER TO dbadmin;

--
-- TOC entry 234 (class 1259 OID 159916)
-- Dependencies: 6
-- Name: core_organisation_unit_has_members; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_organisation_unit_has_members (
    organisation_unit_id integer NOT NULL,
    member_id integer NOT NULL
);


ALTER TABLE public.core_organisation_unit_has_members OWNER TO dbadmin;

--
-- TOC entry 233 (class 1259 OID 159911)
-- Dependencies: 6
-- Name: core_organisation_unit_has_owners; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_organisation_unit_has_owners (
    organisation_unit_id integer NOT NULL,
    owner_id integer NOT NULL,
    master_owner boolean
);


ALTER TABLE public.core_organisation_unit_has_owners OWNER TO dbadmin;

--
-- TOC entry 232 (class 1259 OID 159906)
-- Dependencies: 6
-- Name: core_organisation_unit_has_quality_managers; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_organisation_unit_has_quality_managers (
    organisation_unit_id integer NOT NULL,
    quality_manager_id integer NOT NULL
);


ALTER TABLE public.core_organisation_unit_has_quality_managers OWNER TO dbadmin;

--
-- TOC entry 229 (class 1259 OID 159886)
-- Dependencies: 6
-- Name: core_organisation_unit_types; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_organisation_unit_types (
    id integer NOT NULL,
    name text,
    icon text
);


ALTER TABLE public.core_organisation_unit_types OWNER TO dbadmin;

--
-- TOC entry 228 (class 1259 OID 159884)
-- Dependencies: 229 6
-- Name: core_organisation_unit_types_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_organisation_unit_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_organisation_unit_types_id_seq OWNER TO dbadmin;

--
-- TOC entry 3312 (class 0 OID 0)
-- Dependencies: 228
-- Name: core_organisation_unit_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_organisation_unit_types_id_seq OWNED BY core_organisation_unit_types.id;


--
-- TOC entry 3313 (class 0 OID 0)
-- Dependencies: 228
-- Name: core_organisation_unit_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_organisation_unit_types_id_seq', 3, true);


--
-- TOC entry 231 (class 1259 OID 159897)
-- Dependencies: 6
-- Name: core_organisation_units; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_organisation_units (
    id integer NOT NULL,
    toid integer,
    is_root boolean,
    name text,
    type_id integer,
    stores_data boolean,
    "position" integer,
    hidden boolean
);


ALTER TABLE public.core_organisation_units OWNER TO dbadmin;

--
-- TOC entry 230 (class 1259 OID 159895)
-- Dependencies: 6 231
-- Name: core_organisation_units_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_organisation_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_organisation_units_id_seq OWNER TO dbadmin;

--
-- TOC entry 3314 (class 0 OID 0)
-- Dependencies: 230
-- Name: core_organisation_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_organisation_units_id_seq OWNED BY core_organisation_units.id;


--
-- TOC entry 3315 (class 0 OID 0)
-- Dependencies: 230
-- Name: core_organisation_units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_organisation_units_id_seq', 1, false);


--
-- TOC entry 208 (class 1259 OID 159594)
-- Dependencies: 6
-- Name: core_paper_sizes; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_paper_sizes (
    id integer NOT NULL,
    name text,
    width double precision,
    height double precision,
    margin_left double precision,
    margin_right double precision,
    margin_top double precision,
    margin_bottom double precision,
    base boolean,
    standard boolean
);


ALTER TABLE public.core_paper_sizes OWNER TO dbadmin;

--
-- TOC entry 207 (class 1259 OID 159592)
-- Dependencies: 6 208
-- Name: core_paper_sizes_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_paper_sizes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_paper_sizes_id_seq OWNER TO dbadmin;

--
-- TOC entry 3316 (class 0 OID 0)
-- Dependencies: 207
-- Name: core_paper_sizes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_paper_sizes_id_seq OWNED BY core_paper_sizes.id;


--
-- TOC entry 3317 (class 0 OID 0)
-- Dependencies: 207
-- Name: core_paper_sizes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_paper_sizes_id_seq', 19, true);


--
-- TOC entry 320 (class 1259 OID 160780)
-- Dependencies: 6
-- Name: core_project_has_extension_runs; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_has_extension_runs (
    primary_key integer NOT NULL,
    project_id integer,
    extension_id integer,
    run integer
);


ALTER TABLE public.core_project_has_extension_runs OWNER TO dbadmin;

--
-- TOC entry 319 (class 1259 OID 160778)
-- Dependencies: 6 320
-- Name: core_project_has_extension_runs_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_has_extension_runs_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_has_extension_runs_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3318 (class 0 OID 0)
-- Dependencies: 319
-- Name: core_project_has_extension_runs_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_has_extension_runs_primary_key_seq OWNED BY core_project_has_extension_runs.primary_key;


--
-- TOC entry 3319 (class 0 OID 0)
-- Dependencies: 319
-- Name: core_project_has_extension_runs_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_has_extension_runs_primary_key_seq', 1, false);


--
-- TOC entry 321 (class 1259 OID 160786)
-- Dependencies: 6
-- Name: core_project_has_folder; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_has_folder (
    project_id integer NOT NULL,
    folder_id integer NOT NULL
);


ALTER TABLE public.core_project_has_folder OWNER TO dbadmin;

--
-- TOC entry 323 (class 1259 OID 160793)
-- Dependencies: 6
-- Name: core_project_has_items; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_has_items (
    primary_key integer NOT NULL,
    project_id integer,
    item_id integer,
    active boolean,
    required boolean,
    gid integer,
    project_status_id integer,
    parent_item_id integer
);


ALTER TABLE public.core_project_has_items OWNER TO dbadmin;

--
-- TOC entry 322 (class 1259 OID 160791)
-- Dependencies: 6 323
-- Name: core_project_has_items_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_has_items_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_has_items_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3320 (class 0 OID 0)
-- Dependencies: 322
-- Name: core_project_has_items_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_has_items_primary_key_seq OWNED BY core_project_has_items.primary_key;


--
-- TOC entry 3321 (class 0 OID 0)
-- Dependencies: 322
-- Name: core_project_has_items_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_has_items_primary_key_seq', 1, false);


--
-- TOC entry 325 (class 1259 OID 160801)
-- Dependencies: 6
-- Name: core_project_has_project_status; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_has_project_status (
    primary_key integer NOT NULL,
    project_id integer,
    status_id integer,
    datetime timestamp with time zone,
    current boolean
);


ALTER TABLE public.core_project_has_project_status OWNER TO dbadmin;

--
-- TOC entry 324 (class 1259 OID 160799)
-- Dependencies: 6 325
-- Name: core_project_has_project_status_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_has_project_status_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_has_project_status_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3322 (class 0 OID 0)
-- Dependencies: 324
-- Name: core_project_has_project_status_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_has_project_status_primary_key_seq OWNED BY core_project_has_project_status.primary_key;


--
-- TOC entry 3323 (class 0 OID 0)
-- Dependencies: 324
-- Name: core_project_has_project_status_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_has_project_status_primary_key_seq', 1, false);


--
-- TOC entry 327 (class 1259 OID 160809)
-- Dependencies: 6
-- Name: core_project_links; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_links (
    primary_key integer NOT NULL,
    to_project_id integer,
    project_id integer
);


ALTER TABLE public.core_project_links OWNER TO dbadmin;

--
-- TOC entry 326 (class 1259 OID 160807)
-- Dependencies: 327 6
-- Name: core_project_links_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_links_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_links_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3324 (class 0 OID 0)
-- Dependencies: 326
-- Name: core_project_links_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_links_primary_key_seq OWNED BY core_project_links.primary_key;


--
-- TOC entry 3325 (class 0 OID 0)
-- Dependencies: 326
-- Name: core_project_links_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_links_primary_key_seq', 1, false);


--
-- TOC entry 329 (class 1259 OID 160817)
-- Dependencies: 6
-- Name: core_project_log; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_log (
    id integer NOT NULL,
    project_id integer,
    datetime timestamp with time zone,
    content text,
    cancel boolean,
    important boolean,
    owner_id integer
);


ALTER TABLE public.core_project_log OWNER TO dbadmin;

--
-- TOC entry 331 (class 1259 OID 160828)
-- Dependencies: 6
-- Name: core_project_log_has_items; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_log_has_items (
    primary_key integer NOT NULL,
    project_log_id integer,
    item_id integer
);


ALTER TABLE public.core_project_log_has_items OWNER TO dbadmin;

--
-- TOC entry 330 (class 1259 OID 160826)
-- Dependencies: 331 6
-- Name: core_project_log_has_items_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_log_has_items_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_log_has_items_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3326 (class 0 OID 0)
-- Dependencies: 330
-- Name: core_project_log_has_items_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_log_has_items_primary_key_seq OWNED BY core_project_log_has_items.primary_key;


--
-- TOC entry 3327 (class 0 OID 0)
-- Dependencies: 330
-- Name: core_project_log_has_items_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_log_has_items_primary_key_seq', 1, false);


--
-- TOC entry 333 (class 1259 OID 160836)
-- Dependencies: 6
-- Name: core_project_log_has_project_status; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_log_has_project_status (
    primary_key integer NOT NULL,
    log_id integer,
    status_id integer
);


ALTER TABLE public.core_project_log_has_project_status OWNER TO dbadmin;

--
-- TOC entry 332 (class 1259 OID 160834)
-- Dependencies: 6 333
-- Name: core_project_log_has_project_status_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_log_has_project_status_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_log_has_project_status_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3328 (class 0 OID 0)
-- Dependencies: 332
-- Name: core_project_log_has_project_status_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_log_has_project_status_primary_key_seq OWNED BY core_project_log_has_project_status.primary_key;


--
-- TOC entry 3329 (class 0 OID 0)
-- Dependencies: 332
-- Name: core_project_log_has_project_status_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_log_has_project_status_primary_key_seq', 1, false);


--
-- TOC entry 328 (class 1259 OID 160815)
-- Dependencies: 6 329
-- Name: core_project_log_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_log_id_seq OWNER TO dbadmin;

--
-- TOC entry 3330 (class 0 OID 0)
-- Dependencies: 328
-- Name: core_project_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_log_id_seq OWNED BY core_project_log.id;


--
-- TOC entry 3331 (class 0 OID 0)
-- Dependencies: 328
-- Name: core_project_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_log_id_seq', 1, false);


--
-- TOC entry 335 (class 1259 OID 160846)
-- Dependencies: 6
-- Name: core_project_permissions; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_permissions (
    id integer NOT NULL,
    user_id integer,
    organisation_unit_id integer,
    group_id integer,
    project_id integer,
    permission integer,
    owner_id integer,
    intention integer
);


ALTER TABLE public.core_project_permissions OWNER TO dbadmin;

--
-- TOC entry 334 (class 1259 OID 160844)
-- Dependencies: 335 6
-- Name: core_project_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_permissions_id_seq OWNER TO dbadmin;

--
-- TOC entry 3332 (class 0 OID 0)
-- Dependencies: 334
-- Name: core_project_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_permissions_id_seq OWNED BY core_project_permissions.id;


--
-- TOC entry 3333 (class 0 OID 0)
-- Dependencies: 334
-- Name: core_project_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_permissions_id_seq', 1, false);


--
-- TOC entry 337 (class 1259 OID 160854)
-- Dependencies: 6
-- Name: core_project_status; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_status (
    id integer NOT NULL,
    name text,
    analysis boolean,
    blocked boolean,
    comment text
);


ALTER TABLE public.core_project_status OWNER TO dbadmin;

--
-- TOC entry 338 (class 1259 OID 160863)
-- Dependencies: 6
-- Name: core_project_status_has_folder; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_status_has_folder (
    project_id integer NOT NULL,
    project_status_id integer NOT NULL,
    folder_id integer NOT NULL
);


ALTER TABLE public.core_project_status_has_folder OWNER TO dbadmin;

--
-- TOC entry 336 (class 1259 OID 160852)
-- Dependencies: 337 6
-- Name: core_project_status_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_status_id_seq OWNER TO dbadmin;

--
-- TOC entry 3334 (class 0 OID 0)
-- Dependencies: 336
-- Name: core_project_status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_status_id_seq OWNED BY core_project_status.id;


--
-- TOC entry 3335 (class 0 OID 0)
-- Dependencies: 336
-- Name: core_project_status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_status_id_seq', 999999000, true);


--
-- TOC entry 339 (class 1259 OID 160868)
-- Dependencies: 6
-- Name: core_project_task_has_previous_tasks; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_task_has_previous_tasks (
    task_id integer NOT NULL,
    previous_task_id integer NOT NULL
);


ALTER TABLE public.core_project_task_has_previous_tasks OWNER TO dbadmin;

--
-- TOC entry 340 (class 1259 OID 160873)
-- Dependencies: 6
-- Name: core_project_task_milestones; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_task_milestones (
    task_id integer NOT NULL,
    name text
);


ALTER TABLE public.core_project_task_milestones OWNER TO dbadmin;

--
-- TOC entry 341 (class 1259 OID 160881)
-- Dependencies: 6
-- Name: core_project_task_processes; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_task_processes (
    task_id integer NOT NULL,
    name text,
    progress double precision
);


ALTER TABLE public.core_project_task_processes OWNER TO dbadmin;

--
-- TOC entry 342 (class 1259 OID 160889)
-- Dependencies: 6
-- Name: core_project_task_status_processes; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_task_status_processes (
    task_id integer NOT NULL,
    begin_status_id integer,
    end_status_id integer,
    finalise boolean,
    subtraction_points integer
);


ALTER TABLE public.core_project_task_status_processes OWNER TO dbadmin;

--
-- TOC entry 344 (class 1259 OID 160896)
-- Dependencies: 6
-- Name: core_project_tasks; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_tasks (
    id integer NOT NULL,
    type_id integer,
    project_id integer,
    owner_id integer,
    comment text,
    start_date date,
    start_time time with time zone,
    end_date date,
    end_time time with time zone,
    whole_day boolean,
    auto_connect boolean,
    finished boolean,
    created_at timestamp with time zone,
    finished_at timestamp with time zone,
    over_time boolean
);


ALTER TABLE public.core_project_tasks OWNER TO dbadmin;

--
-- TOC entry 343 (class 1259 OID 160894)
-- Dependencies: 344 6
-- Name: core_project_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_tasks_id_seq OWNER TO dbadmin;

--
-- TOC entry 3336 (class 0 OID 0)
-- Dependencies: 343
-- Name: core_project_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_tasks_id_seq OWNED BY core_project_tasks.id;


--
-- TOC entry 3337 (class 0 OID 0)
-- Dependencies: 343
-- Name: core_project_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_tasks_id_seq', 1, false);


--
-- TOC entry 346 (class 1259 OID 160907)
-- Dependencies: 6
-- Name: core_project_template_cats; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_template_cats (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.core_project_template_cats OWNER TO dbadmin;

--
-- TOC entry 345 (class 1259 OID 160905)
-- Dependencies: 346 6
-- Name: core_project_template_cats_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_project_template_cats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_project_template_cats_id_seq OWNER TO dbadmin;

--
-- TOC entry 3338 (class 0 OID 0)
-- Dependencies: 345
-- Name: core_project_template_cats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_project_template_cats_id_seq OWNED BY core_project_template_cats.id;


--
-- TOC entry 3339 (class 0 OID 0)
-- Dependencies: 345
-- Name: core_project_template_cats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_project_template_cats_id_seq', 3, true);


--
-- TOC entry 347 (class 1259 OID 160916)
-- Dependencies: 6
-- Name: core_project_templates; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_templates (
    id integer NOT NULL,
    name text,
    cat_id integer,
    parent_template boolean,
    template_id integer
);


ALTER TABLE public.core_project_templates OWNER TO dbadmin;

--
-- TOC entry 348 (class 1259 OID 160924)
-- Dependencies: 6
-- Name: core_project_user_data; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_project_user_data (
    user_id integer NOT NULL,
    quota bigint
);


ALTER TABLE public.core_project_user_data OWNER TO dbadmin;

--
-- TOC entry 350 (class 1259 OID 160931)
-- Dependencies: 6
-- Name: core_projects; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_projects (
    id integer NOT NULL,
    toid_organ_unit integer,
    toid_project integer,
    datetime timestamp with time zone,
    name text,
    owner_id integer,
    template_id integer,
    quota bigint,
    filesize bigint,
    deleted boolean
);


ALTER TABLE public.core_projects OWNER TO dbadmin;

--
-- TOC entry 349 (class 1259 OID 160929)
-- Dependencies: 6 350
-- Name: core_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_projects_id_seq OWNER TO dbadmin;

--
-- TOC entry 3340 (class 0 OID 0)
-- Dependencies: 349
-- Name: core_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_projects_id_seq OWNED BY core_projects.id;


--
-- TOC entry 3341 (class 0 OID 0)
-- Dependencies: 349
-- Name: core_projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_projects_id_seq', 1, false);


--
-- TOC entry 352 (class 1259 OID 161164)
-- Dependencies: 6
-- Name: core_sample_has_folder; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_has_folder (
    sample_id integer NOT NULL,
    folder_id integer NOT NULL
);


ALTER TABLE public.core_sample_has_folder OWNER TO dbadmin;

--
-- TOC entry 354 (class 1259 OID 161171)
-- Dependencies: 6
-- Name: core_sample_has_items; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_has_items (
    primary_key integer NOT NULL,
    sample_id integer,
    item_id integer,
    gid integer,
    parent boolean,
    parent_item_id integer
);


ALTER TABLE public.core_sample_has_items OWNER TO dbadmin;

--
-- TOC entry 353 (class 1259 OID 161169)
-- Dependencies: 354 6
-- Name: core_sample_has_items_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_sample_has_items_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_sample_has_items_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3342 (class 0 OID 0)
-- Dependencies: 353
-- Name: core_sample_has_items_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_sample_has_items_primary_key_seq OWNED BY core_sample_has_items.primary_key;


--
-- TOC entry 3343 (class 0 OID 0)
-- Dependencies: 353
-- Name: core_sample_has_items_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_sample_has_items_primary_key_seq', 1, false);


--
-- TOC entry 356 (class 1259 OID 161179)
-- Dependencies: 6
-- Name: core_sample_has_locations; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_has_locations (
    primary_key integer NOT NULL,
    sample_id integer,
    location_id integer,
    datetime timestamp with time zone,
    user_id integer
);


ALTER TABLE public.core_sample_has_locations OWNER TO dbadmin;

--
-- TOC entry 355 (class 1259 OID 161177)
-- Dependencies: 356 6
-- Name: core_sample_has_locations_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_sample_has_locations_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_sample_has_locations_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3344 (class 0 OID 0)
-- Dependencies: 355
-- Name: core_sample_has_locations_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_sample_has_locations_primary_key_seq OWNED BY core_sample_has_locations.primary_key;


--
-- TOC entry 3345 (class 0 OID 0)
-- Dependencies: 355
-- Name: core_sample_has_locations_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_sample_has_locations_primary_key_seq', 1, false);


--
-- TOC entry 358 (class 1259 OID 161187)
-- Dependencies: 6
-- Name: core_sample_has_organisation_units; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_has_organisation_units (
    primary_key integer NOT NULL,
    sample_id integer,
    organisation_unit_id integer
);


ALTER TABLE public.core_sample_has_organisation_units OWNER TO dbadmin;

--
-- TOC entry 357 (class 1259 OID 161185)
-- Dependencies: 6 358
-- Name: core_sample_has_organisation_units_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_sample_has_organisation_units_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_sample_has_organisation_units_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3346 (class 0 OID 0)
-- Dependencies: 357
-- Name: core_sample_has_organisation_units_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_sample_has_organisation_units_primary_key_seq OWNED BY core_sample_has_organisation_units.primary_key;


--
-- TOC entry 3347 (class 0 OID 0)
-- Dependencies: 357
-- Name: core_sample_has_organisation_units_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_sample_has_organisation_units_primary_key_seq', 1, false);


--
-- TOC entry 360 (class 1259 OID 161195)
-- Dependencies: 6
-- Name: core_sample_has_users; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_has_users (
    primary_key integer NOT NULL,
    sample_id integer,
    user_id integer,
    read boolean,
    write boolean
);


ALTER TABLE public.core_sample_has_users OWNER TO dbadmin;

--
-- TOC entry 359 (class 1259 OID 161193)
-- Dependencies: 360 6
-- Name: core_sample_has_users_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_sample_has_users_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_sample_has_users_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3348 (class 0 OID 0)
-- Dependencies: 359
-- Name: core_sample_has_users_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_sample_has_users_primary_key_seq OWNED BY core_sample_has_users.primary_key;


--
-- TOC entry 3349 (class 0 OID 0)
-- Dependencies: 359
-- Name: core_sample_has_users_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_sample_has_users_primary_key_seq', 1, false);


--
-- TOC entry 361 (class 1259 OID 161201)
-- Dependencies: 6
-- Name: core_sample_is_item; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_is_item (
    sample_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.core_sample_is_item OWNER TO dbadmin;

--
-- TOC entry 363 (class 1259 OID 161210)
-- Dependencies: 6
-- Name: core_sample_template_cats; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_template_cats (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.core_sample_template_cats OWNER TO dbadmin;

--
-- TOC entry 362 (class 1259 OID 161208)
-- Dependencies: 6 363
-- Name: core_sample_template_cats_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_sample_template_cats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_sample_template_cats_id_seq OWNER TO dbadmin;

--
-- TOC entry 3350 (class 0 OID 0)
-- Dependencies: 362
-- Name: core_sample_template_cats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_sample_template_cats_id_seq OWNED BY core_sample_template_cats.id;


--
-- TOC entry 3351 (class 0 OID 0)
-- Dependencies: 362
-- Name: core_sample_template_cats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_sample_template_cats_id_seq', 4, true);


--
-- TOC entry 364 (class 1259 OID 161219)
-- Dependencies: 6
-- Name: core_sample_templates; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sample_templates (
    id integer NOT NULL,
    name text,
    cat_id integer,
    template_id integer
);


ALTER TABLE public.core_sample_templates OWNER TO dbadmin;

--
-- TOC entry 366 (class 1259 OID 161229)
-- Dependencies: 6
-- Name: core_samples; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_samples (
    id integer NOT NULL,
    name text,
    datetime timestamp with time zone,
    owner_id integer,
    template_id integer,
    available boolean,
    deleted boolean,
    comment text,
    comment_text_search_vector tsvector,
    language_id integer,
    date_of_expiry date,
    expiry_warning bigint,
    manufacturer_id integer
);


ALTER TABLE public.core_samples OWNER TO dbadmin;

--
-- TOC entry 365 (class 1259 OID 161227)
-- Dependencies: 366 6
-- Name: core_samples_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_samples_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_samples_id_seq OWNER TO dbadmin;

--
-- TOC entry 3352 (class 0 OID 0)
-- Dependencies: 365
-- Name: core_samples_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_samples_id_seq OWNED BY core_samples.id;


--
-- TOC entry 3353 (class 0 OID 0)
-- Dependencies: 365
-- Name: core_samples_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_samples_id_seq', 1, false);


--
-- TOC entry 209 (class 1259 OID 159603)
-- Dependencies: 6
-- Name: core_service_has_log_entries; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_service_has_log_entries (
    service_id integer NOT NULL,
    log_entry_id integer NOT NULL
);


ALTER TABLE public.core_service_has_log_entries OWNER TO dbadmin;

--
-- TOC entry 211 (class 1259 OID 159610)
-- Dependencies: 6
-- Name: core_services; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_services (
    id integer NOT NULL,
    name text,
    binary_id integer,
    status integer,
    last_lifesign timestamp with time zone
);


ALTER TABLE public.core_services OWNER TO dbadmin;

--
-- TOC entry 210 (class 1259 OID 159608)
-- Dependencies: 211 6
-- Name: core_services_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_services_id_seq OWNER TO dbadmin;

--
-- TOC entry 3354 (class 0 OID 0)
-- Dependencies: 210
-- Name: core_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_services_id_seq OWNED BY core_services.id;


--
-- TOC entry 3355 (class 0 OID 0)
-- Dependencies: 210
-- Name: core_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_services_id_seq', 1, false);


--
-- TOC entry 213 (class 1259 OID 159621)
-- Dependencies: 6
-- Name: core_session_values; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_session_values (
    id integer NOT NULL,
    session_id character(32),
    address text,
    value text
);


ALTER TABLE public.core_session_values OWNER TO dbadmin;

--
-- TOC entry 212 (class 1259 OID 159619)
-- Dependencies: 213 6
-- Name: core_session_values_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_session_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_session_values_id_seq OWNER TO dbadmin;

--
-- TOC entry 3356 (class 0 OID 0)
-- Dependencies: 212
-- Name: core_session_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_session_values_id_seq OWNED BY core_session_values.id;


--
-- TOC entry 3357 (class 0 OID 0)
-- Dependencies: 212
-- Name: core_session_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_session_values_id_seq', 1, false);


--
-- TOC entry 214 (class 1259 OID 159632)
-- Dependencies: 6
-- Name: core_sessions; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_sessions (
    session_id character(32) NOT NULL,
    ip inet,
    user_id integer,
    datetime timestamp with time zone
);


ALTER TABLE public.core_sessions OWNER TO dbadmin;

--
-- TOC entry 216 (class 1259 OID 159642)
-- Dependencies: 6
-- Name: core_system_log; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_system_log (
    id integer NOT NULL,
    type_id integer,
    user_id integer,
    datetime timestamp with time zone,
    ip inet,
    content_int integer,
    content_string text,
    content_errorno text,
    file text,
    line integer,
    link text,
    stack_trace text
);


ALTER TABLE public.core_system_log OWNER TO dbadmin;

--
-- TOC entry 215 (class 1259 OID 159640)
-- Dependencies: 6 216
-- Name: core_system_log_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_system_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_system_log_id_seq OWNER TO dbadmin;

--
-- TOC entry 3358 (class 0 OID 0)
-- Dependencies: 215
-- Name: core_system_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_system_log_id_seq OWNED BY core_system_log.id;


--
-- TOC entry 3359 (class 0 OID 0)
-- Dependencies: 215
-- Name: core_system_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_system_log_id_seq', 1, false);


--
-- TOC entry 218 (class 1259 OID 159653)
-- Dependencies: 6
-- Name: core_system_log_types; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_system_log_types (
    id integer NOT NULL,
    name text
);


ALTER TABLE public.core_system_log_types OWNER TO dbadmin;

--
-- TOC entry 217 (class 1259 OID 159651)
-- Dependencies: 218 6
-- Name: core_system_log_types_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_system_log_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_system_log_types_id_seq OWNER TO dbadmin;

--
-- TOC entry 3360 (class 0 OID 0)
-- Dependencies: 217
-- Name: core_system_log_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_system_log_types_id_seq OWNED BY core_system_log_types.id;


--
-- TOC entry 3361 (class 0 OID 0)
-- Dependencies: 217
-- Name: core_system_log_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_system_log_types_id_seq', 5, true);


--
-- TOC entry 220 (class 1259 OID 159664)
-- Dependencies: 6
-- Name: core_system_messages; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_system_messages (
    id integer NOT NULL,
    user_id integer,
    datetime timestamp with time zone,
    content text
);


ALTER TABLE public.core_system_messages OWNER TO dbadmin;

--
-- TOC entry 219 (class 1259 OID 159662)
-- Dependencies: 6 220
-- Name: core_system_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_system_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_system_messages_id_seq OWNER TO dbadmin;

--
-- TOC entry 3362 (class 0 OID 0)
-- Dependencies: 219
-- Name: core_system_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_system_messages_id_seq OWNED BY core_system_messages.id;


--
-- TOC entry 3363 (class 0 OID 0)
-- Dependencies: 219
-- Name: core_system_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_system_messages_id_seq', 1, false);


--
-- TOC entry 222 (class 1259 OID 159675)
-- Dependencies: 6
-- Name: core_timezones; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_timezones (
    id integer NOT NULL,
    title text,
    php_title text,
    deviation double precision
);


ALTER TABLE public.core_timezones OWNER TO dbadmin;

--
-- TOC entry 221 (class 1259 OID 159673)
-- Dependencies: 6 222
-- Name: core_timezones_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_timezones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_timezones_id_seq OWNER TO dbadmin;

--
-- TOC entry 3364 (class 0 OID 0)
-- Dependencies: 221
-- Name: core_timezones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_timezones_id_seq OWNED BY core_timezones.id;


--
-- TOC entry 3365 (class 0 OID 0)
-- Dependencies: 221
-- Name: core_timezones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_timezones_id_seq', 67, true);


--
-- TOC entry 223 (class 1259 OID 159684)
-- Dependencies: 6
-- Name: core_user_admin_settings; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_user_admin_settings (
    id integer NOT NULL,
    can_change_password boolean,
    must_change_password boolean,
    user_locked boolean,
    user_inactive boolean,
    secure_password boolean,
    last_password_change timestamp with time zone,
    block_write boolean,
    create_folder boolean
);


ALTER TABLE public.core_user_admin_settings OWNER TO dbadmin;

--
-- TOC entry 224 (class 1259 OID 159689)
-- Dependencies: 6
-- Name: core_user_profiles; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_user_profiles (
    id integer NOT NULL,
    gender character(1),
    title text,
    forename text,
    surname text,
    mail text,
    institution text,
    department text,
    street text,
    zip text,
    city text,
    country text,
    phone text,
    icq integer,
    msn text,
    yahoo text,
    aim text,
    skype text,
    lync text,
    jabber text
);


ALTER TABLE public.core_user_profiles OWNER TO dbadmin;

--
-- TOC entry 225 (class 1259 OID 159697)
-- Dependencies: 6
-- Name: core_user_regional_settings; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_user_regional_settings (
    id integer NOT NULL,
    language_id integer,
    timezone_id integer,
    time_display_format boolean,
    time_enter_format boolean,
    date_display_format text,
    date_enter_format text,
    country_id integer,
    system_of_units text,
    system_of_paper_format text,
    currency_id integer,
    currency_significant_digits integer,
    decimal_separator text,
    thousand_separator text,
    name_display_format text
);


ALTER TABLE public.core_user_regional_settings OWNER TO dbadmin;

--
-- TOC entry 227 (class 1259 OID 159707)
-- Dependencies: 6
-- Name: core_users; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_users (
    id integer NOT NULL,
    username text,
    password character(32)
);


ALTER TABLE public.core_users OWNER TO dbadmin;

--
-- TOC entry 226 (class 1259 OID 159705)
-- Dependencies: 6 227
-- Name: core_users_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_users_id_seq OWNER TO dbadmin;

--
-- TOC entry 3366 (class 0 OID 0)
-- Dependencies: 226
-- Name: core_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_users_id_seq OWNED BY core_users.id;


--
-- TOC entry 3367 (class 0 OID 0)
-- Dependencies: 226
-- Name: core_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_users_id_seq', 100, true);


--
-- TOC entry 304 (class 1259 OID 160380)
-- Dependencies: 6
-- Name: core_value_types; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_value_types (
    id integer NOT NULL,
    name text,
    template_id integer
);


ALTER TABLE public.core_value_types OWNER TO dbadmin;

--
-- TOC entry 303 (class 1259 OID 160378)
-- Dependencies: 304 6
-- Name: core_value_types_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_value_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_value_types_id_seq OWNER TO dbadmin;

--
-- TOC entry 3368 (class 0 OID 0)
-- Dependencies: 303
-- Name: core_value_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_value_types_id_seq OWNED BY core_value_types.id;


--
-- TOC entry 3369 (class 0 OID 0)
-- Dependencies: 303
-- Name: core_value_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_value_types_id_seq', 1, false);


--
-- TOC entry 306 (class 1259 OID 160391)
-- Dependencies: 6
-- Name: core_value_var_cases; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_value_var_cases (
    id integer NOT NULL,
    name text,
    handling_class text,
    ignore_this boolean,
    include_id integer
);


ALTER TABLE public.core_value_var_cases OWNER TO dbadmin;

--
-- TOC entry 305 (class 1259 OID 160389)
-- Dependencies: 6 306
-- Name: core_value_var_cases_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_value_var_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_value_var_cases_id_seq OWNER TO dbadmin;

--
-- TOC entry 3370 (class 0 OID 0)
-- Dependencies: 305
-- Name: core_value_var_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_value_var_cases_id_seq OWNED BY core_value_var_cases.id;


--
-- TOC entry 3371 (class 0 OID 0)
-- Dependencies: 305
-- Name: core_value_var_cases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_value_var_cases_id_seq', 3, true);


--
-- TOC entry 308 (class 1259 OID 160402)
-- Dependencies: 6
-- Name: core_value_versions; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_value_versions (
    id integer NOT NULL,
    toid integer,
    version integer,
    value text,
    text_search_vector tsvector,
    checksum character(32),
    datetime timestamp with time zone,
    language_id integer,
    previous_version_id integer,
    internal_revision integer,
    current boolean,
    owner_id integer,
    name text
);


ALTER TABLE public.core_value_versions OWNER TO dbadmin;

--
-- TOC entry 307 (class 1259 OID 160400)
-- Dependencies: 6 308
-- Name: core_value_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_value_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_value_versions_id_seq OWNER TO dbadmin;

--
-- TOC entry 3372 (class 0 OID 0)
-- Dependencies: 307
-- Name: core_value_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_value_versions_id_seq OWNED BY core_value_versions.id;


--
-- TOC entry 3373 (class 0 OID 0)
-- Dependencies: 307
-- Name: core_value_versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_value_versions_id_seq', 1, false);


--
-- TOC entry 310 (class 1259 OID 160415)
-- Dependencies: 6
-- Name: core_values; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_values (
    id integer NOT NULL,
    data_entity_id integer,
    type_id integer
);


ALTER TABLE public.core_values OWNER TO dbadmin;

--
-- TOC entry 309 (class 1259 OID 160413)
-- Dependencies: 310 6
-- Name: core_values_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_values_id_seq OWNER TO dbadmin;

--
-- TOC entry 3374 (class 0 OID 0)
-- Dependencies: 309
-- Name: core_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_values_id_seq OWNED BY core_values.id;


--
-- TOC entry 3375 (class 0 OID 0)
-- Dependencies: 309
-- Name: core_values_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_values_id_seq', 1, false);


--
-- TOC entry 351 (class 1259 OID 160940)
-- Dependencies: 6
-- Name: core_virtual_folder_is_project; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_virtual_folder_is_project (
    id integer NOT NULL
);


ALTER TABLE public.core_virtual_folder_is_project OWNER TO dbadmin;

--
-- TOC entry 367 (class 1259 OID 161238)
-- Dependencies: 6
-- Name: core_virtual_folder_is_sample; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_virtual_folder_is_sample (
    id integer NOT NULL
);


ALTER TABLE public.core_virtual_folder_is_sample OWNER TO dbadmin;

--
-- TOC entry 312 (class 1259 OID 160423)
-- Dependencies: 6
-- Name: core_virtual_folders; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_virtual_folders (
    id integer NOT NULL,
    data_entity_id integer,
    name text
);


ALTER TABLE public.core_virtual_folders OWNER TO dbadmin;

--
-- TOC entry 311 (class 1259 OID 160421)
-- Dependencies: 312 6
-- Name: core_virtual_folders_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_virtual_folders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_virtual_folders_id_seq OWNER TO dbadmin;

--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 311
-- Name: core_virtual_folders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_virtual_folders_id_seq OWNED BY core_virtual_folders.id;


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 311
-- Name: core_virtual_folders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_virtual_folders_id_seq', 12, true);


--
-- TOC entry 258 (class 1259 OID 160134)
-- Dependencies: 6
-- Name: core_xml_cache; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_xml_cache (
    id integer NOT NULL,
    data_entity_id integer,
    path text,
    checksum character(32)
);


ALTER TABLE public.core_xml_cache OWNER TO dbadmin;

--
-- TOC entry 260 (class 1259 OID 160145)
-- Dependencies: 6
-- Name: core_xml_cache_elements; Type: TABLE; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE TABLE core_xml_cache_elements (
    primary_key integer NOT NULL,
    toid integer,
    field_0 text,
    field_1 text,
    field_2 text,
    field_3 text
);


ALTER TABLE public.core_xml_cache_elements OWNER TO dbadmin;

--
-- TOC entry 259 (class 1259 OID 160143)
-- Dependencies: 6 260
-- Name: core_xml_cache_elements_primary_key_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_xml_cache_elements_primary_key_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_xml_cache_elements_primary_key_seq OWNER TO dbadmin;

--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 259
-- Name: core_xml_cache_elements_primary_key_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_xml_cache_elements_primary_key_seq OWNED BY core_xml_cache_elements.primary_key;


--
-- TOC entry 3379 (class 0 OID 0)
-- Dependencies: 259
-- Name: core_xml_cache_elements_primary_key_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_xml_cache_elements_primary_key_seq', 1, false);


--
-- TOC entry 257 (class 1259 OID 160132)
-- Dependencies: 258 6
-- Name: core_xml_cache_id_seq; Type: SEQUENCE; Schema: public; Owner: dbadmin
--

CREATE SEQUENCE core_xml_cache_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.core_xml_cache_id_seq OWNER TO dbadmin;

--
-- TOC entry 3380 (class 0 OID 0)
-- Dependencies: 257
-- Name: core_xml_cache_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: dbadmin
--

ALTER SEQUENCE core_xml_cache_id_seq OWNED BY core_xml_cache.id;


--
-- TOC entry 3381 (class 0 OID 0)
-- Dependencies: 257
-- Name: core_xml_cache_id_seq; Type: SEQUENCE SET; Schema: public; Owner: dbadmin
--

SELECT pg_catalog.setval('core_xml_cache_id_seq', 1, false);


--
-- TOC entry 2485 (class 2604 OID 159345)
-- Dependencies: 161 162 162
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_batch_runs ALTER COLUMN id SET DEFAULT nextval('core_base_batch_runs_id_seq'::regclass);


--
-- TOC entry 2486 (class 2604 OID 159353)
-- Dependencies: 164 163 164
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_batch_types ALTER COLUMN id SET DEFAULT nextval('core_base_batch_types_id_seq'::regclass);


--
-- TOC entry 2487 (class 2604 OID 159366)
-- Dependencies: 166 165 166
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_event_listeners ALTER COLUMN id SET DEFAULT nextval('core_base_event_listeners_id_seq'::regclass);


--
-- TOC entry 2488 (class 2604 OID 159377)
-- Dependencies: 168 167 168
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_include_files ALTER COLUMN id SET DEFAULT nextval('core_base_include_files_id_seq'::regclass);


--
-- TOC entry 2489 (class 2604 OID 159388)
-- Dependencies: 170 169 170
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_include_functions ALTER COLUMN id SET DEFAULT nextval('core_base_include_functions_id_seq'::regclass);


--
-- TOC entry 2490 (class 2604 OID 159399)
-- Dependencies: 172 171 172
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_include_tables ALTER COLUMN id SET DEFAULT nextval('core_base_include_tables_id_seq'::regclass);


--
-- TOC entry 2491 (class 2604 OID 159410)
-- Dependencies: 173 174 174
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_includes ALTER COLUMN id SET DEFAULT nextval('core_base_includes_id_seq'::regclass);


--
-- TOC entry 2492 (class 2604 OID 159421)
-- Dependencies: 175 176 176
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_measuring_unit_categories ALTER COLUMN id SET DEFAULT nextval('core_base_measuring_unit_categories_id_seq'::regclass);


--
-- TOC entry 2493 (class 2604 OID 159432)
-- Dependencies: 177 178 178
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_measuring_unit_ratios ALTER COLUMN id SET DEFAULT nextval('core_base_measuring_unit_ratios_id_seq'::regclass);


--
-- TOC entry 2494 (class 2604 OID 159440)
-- Dependencies: 180 179 180
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_measuring_units ALTER COLUMN id SET DEFAULT nextval('core_base_measuring_units_id_seq'::regclass);


--
-- TOC entry 2495 (class 2604 OID 159451)
-- Dependencies: 181 182 182
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_module_dialogs ALTER COLUMN id SET DEFAULT nextval('core_base_module_dialogs_id_seq'::regclass);


--
-- TOC entry 2496 (class 2604 OID 159462)
-- Dependencies: 184 183 184
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_module_files ALTER COLUMN id SET DEFAULT nextval('core_base_module_files_id_seq'::regclass);


--
-- TOC entry 2497 (class 2604 OID 159473)
-- Dependencies: 185 186 186
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_module_links ALTER COLUMN id SET DEFAULT nextval('core_base_module_links_id_seq'::regclass);


--
-- TOC entry 2498 (class 2604 OID 159484)
-- Dependencies: 188 187 188
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_module_navigation ALTER COLUMN id SET DEFAULT nextval('core_base_module_navigation_id_seq'::regclass);


--
-- TOC entry 2499 (class 2604 OID 159497)
-- Dependencies: 190 189 190
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_modules ALTER COLUMN id SET DEFAULT nextval('core_base_modules_id_seq'::regclass);


--
-- TOC entry 2500 (class 2604 OID 159508)
-- Dependencies: 192 191 192
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_base_registry ALTER COLUMN id SET DEFAULT nextval('core_base_registry_id_seq'::regclass);


--
-- TOC entry 2501 (class 2604 OID 159521)
-- Dependencies: 194 193 194
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_binaries ALTER COLUMN id SET DEFAULT nextval('core_binaries_id_seq'::regclass);


--
-- TOC entry 2502 (class 2604 OID 159532)
-- Dependencies: 196 195 196
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_countries ALTER COLUMN id SET DEFAULT nextval('core_countries_id_seq'::regclass);


--
-- TOC entry 2503 (class 2604 OID 159543)
-- Dependencies: 197 198 198
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_currencies ALTER COLUMN id SET DEFAULT nextval('core_currencies_id_seq'::regclass);


--
-- TOC entry 2530 (class 2604 OID 160159)
-- Dependencies: 261 262 262
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_entities ALTER COLUMN id SET DEFAULT nextval('core_data_entities_id_seq'::regclass);


--
-- TOC entry 2531 (class 2604 OID 160189)
-- Dependencies: 267 268 268
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameter_field_values ALTER COLUMN id SET DEFAULT nextval('core_data_parameter_field_values_id_seq'::regclass);


--
-- TOC entry 2532 (class 2604 OID 160200)
-- Dependencies: 269 270 270
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameter_fields ALTER COLUMN id SET DEFAULT nextval('core_data_parameter_fields_id_seq'::regclass);


--
-- TOC entry 2533 (class 2604 OID 160225)
-- Dependencies: 274 273 274
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameter_limits ALTER COLUMN id SET DEFAULT nextval('core_data_parameter_limits_id_seq'::regclass);


--
-- TOC entry 2534 (class 2604 OID 160236)
-- Dependencies: 276 275 276
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameter_methods ALTER COLUMN id SET DEFAULT nextval('core_data_parameter_methods_id_seq'::regclass);


--
-- TOC entry 2535 (class 2604 OID 160252)
-- Dependencies: 279 278 279
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameter_non_templates ALTER COLUMN id SET DEFAULT nextval('core_data_parameter_non_templates_id_seq'::regclass);


--
-- TOC entry 2536 (class 2604 OID 160265)
-- Dependencies: 281 282 282
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameter_templates ALTER COLUMN id SET DEFAULT nextval('core_data_parameter_templates_id_seq'::regclass);


--
-- TOC entry 2537 (class 2604 OID 160278)
-- Dependencies: 284 283 284
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameter_versions ALTER COLUMN id SET DEFAULT nextval('core_data_parameter_versions_id_seq'::regclass);


--
-- TOC entry 2538 (class 2604 OID 160289)
-- Dependencies: 286 285 286
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_data_parameters ALTER COLUMN id SET DEFAULT nextval('core_data_parameters_id_seq'::regclass);


--
-- TOC entry 2570 (class 2604 OID 161357)
-- Dependencies: 368 369 369
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_equipment ALTER COLUMN id SET DEFAULT nextval('core_equipment_id_seq'::regclass);


--
-- TOC entry 2571 (class 2604 OID 161365)
-- Dependencies: 371 370 371
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_equipment_cats ALTER COLUMN id SET DEFAULT nextval('core_equipment_cats_id_seq'::regclass);


--
-- TOC entry 2572 (class 2604 OID 161393)
-- Dependencies: 375 376 376
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_equipment_types ALTER COLUMN id SET DEFAULT nextval('core_equipment_types_id_seq'::regclass);


--
-- TOC entry 2504 (class 2604 OID 159554)
-- Dependencies: 199 200 200
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_extensions ALTER COLUMN id SET DEFAULT nextval('core_extensions_id_seq'::regclass);


--
-- TOC entry 2539 (class 2604 OID 160302)
-- Dependencies: 289 288 289
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_file_image_cache ALTER COLUMN id SET DEFAULT nextval('core_file_image_cache_id_seq'::regclass);


--
-- TOC entry 2540 (class 2604 OID 160318)
-- Dependencies: 292 291 292
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_file_versions ALTER COLUMN id SET DEFAULT nextval('core_file_versions_id_seq'::regclass);


--
-- TOC entry 2541 (class 2604 OID 160331)
-- Dependencies: 293 294 294
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_files ALTER COLUMN id SET DEFAULT nextval('core_files_id_seq'::regclass);


--
-- TOC entry 2542 (class 2604 OID 160339)
-- Dependencies: 295 296 296
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_folder_concretion ALTER COLUMN id SET DEFAULT nextval('core_folder_concretion_id_seq'::regclass);


--
-- TOC entry 2543 (class 2604 OID 160370)
-- Dependencies: 302 301 302
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_folders ALTER COLUMN id SET DEFAULT nextval('core_folders_id_seq'::regclass);


--
-- TOC entry 2505 (class 2604 OID 159567)
-- Dependencies: 201 202 202
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_group_has_users ALTER COLUMN primary_key SET DEFAULT nextval('core_group_has_users_primary_key_seq'::regclass);


--
-- TOC entry 2506 (class 2604 OID 159575)
-- Dependencies: 204 203 204
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_groups ALTER COLUMN id SET DEFAULT nextval('core_groups_id_seq'::regclass);


--
-- TOC entry 2518 (class 2604 OID 159998)
-- Dependencies: 237 238 238
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_item_class_has_item_information ALTER COLUMN primary_key SET DEFAULT nextval('core_item_class_has_item_information_primary_key_seq'::regclass);


--
-- TOC entry 2519 (class 2604 OID 160006)
-- Dependencies: 239 240 240
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_item_classes ALTER COLUMN id SET DEFAULT nextval('core_item_classes_id_seq'::regclass);


--
-- TOC entry 2520 (class 2604 OID 160017)
-- Dependencies: 242 241 242
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_item_concretion ALTER COLUMN id SET DEFAULT nextval('core_item_concretion_id_seq'::regclass);


--
-- TOC entry 2521 (class 2604 OID 160028)
-- Dependencies: 243 244 244
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_item_has_item_classes ALTER COLUMN primary_key SET DEFAULT nextval('core_item_has_item_classes_primary_key_seq'::regclass);


--
-- TOC entry 2522 (class 2604 OID 160036)
-- Dependencies: 245 246 246
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_item_has_item_information ALTER COLUMN primary_key SET DEFAULT nextval('core_item_has_item_information_primary_key_seq'::regclass);


--
-- TOC entry 2523 (class 2604 OID 160044)
-- Dependencies: 247 248 248
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_item_holders ALTER COLUMN id SET DEFAULT nextval('core_item_holders_id_seq'::regclass);


--
-- TOC entry 2524 (class 2604 OID 160055)
-- Dependencies: 249 250 250
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_item_information ALTER COLUMN id SET DEFAULT nextval('core_item_information_id_seq'::regclass);


--
-- TOC entry 2525 (class 2604 OID 160066)
-- Dependencies: 252 251 252
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_items ALTER COLUMN id SET DEFAULT nextval('core_items_id_seq'::regclass);


--
-- TOC entry 2507 (class 2604 OID 159586)
-- Dependencies: 205 206 206
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_languages ALTER COLUMN id SET DEFAULT nextval('core_languages_id_seq'::regclass);


--
-- TOC entry 2549 (class 2604 OID 160734)
-- Dependencies: 314 313 314
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_location_types ALTER COLUMN id SET DEFAULT nextval('core_location_types_id_seq'::regclass);


--
-- TOC entry 2550 (class 2604 OID 160745)
-- Dependencies: 316 315 316
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_locations ALTER COLUMN id SET DEFAULT nextval('core_locations_id_seq'::regclass);


--
-- TOC entry 2551 (class 2604 OID 160766)
-- Dependencies: 317 318 318
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_manufacturers ALTER COLUMN id SET DEFAULT nextval('core_manufacturers_id_seq'::regclass);


--
-- TOC entry 2526 (class 2604 OID 160121)
-- Dependencies: 254 253 254
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_oldl_templates ALTER COLUMN id SET DEFAULT nextval('core_oldl_templates_id_seq'::regclass);


--
-- TOC entry 2527 (class 2604 OID 160129)
-- Dependencies: 256 255 256
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_olvdl_templates ALTER COLUMN id SET DEFAULT nextval('core_olvdl_templates_id_seq'::regclass);


--
-- TOC entry 2516 (class 2604 OID 159889)
-- Dependencies: 228 229 229
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_organisation_unit_types ALTER COLUMN id SET DEFAULT nextval('core_organisation_unit_types_id_seq'::regclass);


--
-- TOC entry 2517 (class 2604 OID 159900)
-- Dependencies: 230 231 231
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_organisation_units ALTER COLUMN id SET DEFAULT nextval('core_organisation_units_id_seq'::regclass);


--
-- TOC entry 2508 (class 2604 OID 159597)
-- Dependencies: 208 207 208
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_paper_sizes ALTER COLUMN id SET DEFAULT nextval('core_paper_sizes_id_seq'::regclass);


--
-- TOC entry 2552 (class 2604 OID 160783)
-- Dependencies: 320 319 320
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_has_extension_runs ALTER COLUMN primary_key SET DEFAULT nextval('core_project_has_extension_runs_primary_key_seq'::regclass);


--
-- TOC entry 2553 (class 2604 OID 160796)
-- Dependencies: 322 323 323
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_has_items ALTER COLUMN primary_key SET DEFAULT nextval('core_project_has_items_primary_key_seq'::regclass);


--
-- TOC entry 2554 (class 2604 OID 160804)
-- Dependencies: 324 325 325
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_has_project_status ALTER COLUMN primary_key SET DEFAULT nextval('core_project_has_project_status_primary_key_seq'::regclass);


--
-- TOC entry 2555 (class 2604 OID 160812)
-- Dependencies: 327 326 327
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_links ALTER COLUMN primary_key SET DEFAULT nextval('core_project_links_primary_key_seq'::regclass);


--
-- TOC entry 2556 (class 2604 OID 160820)
-- Dependencies: 329 328 329
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_log ALTER COLUMN id SET DEFAULT nextval('core_project_log_id_seq'::regclass);


--
-- TOC entry 2557 (class 2604 OID 160831)
-- Dependencies: 331 330 331
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_log_has_items ALTER COLUMN primary_key SET DEFAULT nextval('core_project_log_has_items_primary_key_seq'::regclass);


--
-- TOC entry 2558 (class 2604 OID 160839)
-- Dependencies: 332 333 333
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_log_has_project_status ALTER COLUMN primary_key SET DEFAULT nextval('core_project_log_has_project_status_primary_key_seq'::regclass);


--
-- TOC entry 2559 (class 2604 OID 160849)
-- Dependencies: 334 335 335
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_permissions ALTER COLUMN id SET DEFAULT nextval('core_project_permissions_id_seq'::regclass);


--
-- TOC entry 2560 (class 2604 OID 160857)
-- Dependencies: 337 336 337
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_status ALTER COLUMN id SET DEFAULT nextval('core_project_status_id_seq'::regclass);


--
-- TOC entry 2561 (class 2604 OID 160899)
-- Dependencies: 343 344 344
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_tasks ALTER COLUMN id SET DEFAULT nextval('core_project_tasks_id_seq'::regclass);


--
-- TOC entry 2562 (class 2604 OID 160910)
-- Dependencies: 346 345 346
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_project_template_cats ALTER COLUMN id SET DEFAULT nextval('core_project_template_cats_id_seq'::regclass);


--
-- TOC entry 2563 (class 2604 OID 160934)
-- Dependencies: 350 349 350
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_projects ALTER COLUMN id SET DEFAULT nextval('core_projects_id_seq'::regclass);


--
-- TOC entry 2564 (class 2604 OID 161174)
-- Dependencies: 353 354 354
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_sample_has_items ALTER COLUMN primary_key SET DEFAULT nextval('core_sample_has_items_primary_key_seq'::regclass);


--
-- TOC entry 2565 (class 2604 OID 161182)
-- Dependencies: 356 355 356
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_sample_has_locations ALTER COLUMN primary_key SET DEFAULT nextval('core_sample_has_locations_primary_key_seq'::regclass);


--
-- TOC entry 2566 (class 2604 OID 161190)
-- Dependencies: 357 358 358
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_sample_has_organisation_units ALTER COLUMN primary_key SET DEFAULT nextval('core_sample_has_organisation_units_primary_key_seq'::regclass);


--
-- TOC entry 2567 (class 2604 OID 161198)
-- Dependencies: 359 360 360
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_sample_has_users ALTER COLUMN primary_key SET DEFAULT nextval('core_sample_has_users_primary_key_seq'::regclass);


--
-- TOC entry 2568 (class 2604 OID 161213)
-- Dependencies: 362 363 363
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_sample_template_cats ALTER COLUMN id SET DEFAULT nextval('core_sample_template_cats_id_seq'::regclass);


--
-- TOC entry 2569 (class 2604 OID 161232)
-- Dependencies: 365 366 366
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_samples ALTER COLUMN id SET DEFAULT nextval('core_samples_id_seq'::regclass);


--
-- TOC entry 2509 (class 2604 OID 159613)
-- Dependencies: 210 211 211
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_services ALTER COLUMN id SET DEFAULT nextval('core_services_id_seq'::regclass);


--
-- TOC entry 2510 (class 2604 OID 159624)
-- Dependencies: 213 212 213
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_session_values ALTER COLUMN id SET DEFAULT nextval('core_session_values_id_seq'::regclass);


--
-- TOC entry 2511 (class 2604 OID 159645)
-- Dependencies: 216 215 216
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_system_log ALTER COLUMN id SET DEFAULT nextval('core_system_log_id_seq'::regclass);


--
-- TOC entry 2512 (class 2604 OID 159656)
-- Dependencies: 218 217 218
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_system_log_types ALTER COLUMN id SET DEFAULT nextval('core_system_log_types_id_seq'::regclass);


--
-- TOC entry 2513 (class 2604 OID 159667)
-- Dependencies: 219 220 220
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_system_messages ALTER COLUMN id SET DEFAULT nextval('core_system_messages_id_seq'::regclass);


--
-- TOC entry 2514 (class 2604 OID 159678)
-- Dependencies: 221 222 222
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_timezones ALTER COLUMN id SET DEFAULT nextval('core_timezones_id_seq'::regclass);


--
-- TOC entry 2515 (class 2604 OID 159710)
-- Dependencies: 226 227 227
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_users ALTER COLUMN id SET DEFAULT nextval('core_users_id_seq'::regclass);


--
-- TOC entry 2544 (class 2604 OID 160383)
-- Dependencies: 304 303 304
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_value_types ALTER COLUMN id SET DEFAULT nextval('core_value_types_id_seq'::regclass);


--
-- TOC entry 2545 (class 2604 OID 160394)
-- Dependencies: 305 306 306
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_value_var_cases ALTER COLUMN id SET DEFAULT nextval('core_value_var_cases_id_seq'::regclass);


--
-- TOC entry 2546 (class 2604 OID 160405)
-- Dependencies: 307 308 308
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_value_versions ALTER COLUMN id SET DEFAULT nextval('core_value_versions_id_seq'::regclass);


--
-- TOC entry 2547 (class 2604 OID 160418)
-- Dependencies: 310 309 310
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_values ALTER COLUMN id SET DEFAULT nextval('core_values_id_seq'::regclass);


--
-- TOC entry 2548 (class 2604 OID 160426)
-- Dependencies: 312 311 312
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_virtual_folders ALTER COLUMN id SET DEFAULT nextval('core_virtual_folders_id_seq'::regclass);


--
-- TOC entry 2528 (class 2604 OID 160137)
-- Dependencies: 257 258 258
-- Name: id; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_xml_cache ALTER COLUMN id SET DEFAULT nextval('core_xml_cache_id_seq'::regclass);


--
-- TOC entry 2529 (class 2604 OID 160148)
-- Dependencies: 260 259 260
-- Name: primary_key; Type: DEFAULT; Schema: public; Owner: dbadmin
--

ALTER TABLE core_xml_cache_elements ALTER COLUMN primary_key SET DEFAULT nextval('core_xml_cache_elements_primary_key_seq'::regclass);


--
-- TOC entry 3072 (class 0 OID 159342)
-- Dependencies: 162
-- Data for Name: core_base_batch_runs; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_batch_runs (id, binary_id, status, create_datetime, start_datetime, end_datetime, last_lifesign, user_id, type_id) FROM stdin;
\.


--
-- TOC entry 3073 (class 0 OID 159350)
-- Dependencies: 164
-- Data for Name: core_base_batch_types; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_batch_types (id, name, internal_name, binary_id) FROM stdin;
\.


--
-- TOC entry 3074 (class 0 OID 159363)
-- Dependencies: 166
-- Data for Name: core_base_event_listeners; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_event_listeners (id, include_id, class_name) FROM stdin;
1	1	SystemMessage
2	1	ModuleNavigation
3	1	ModuleLink
4	1	ModuleDialog
5	1	Registry
6	1	ExtensionHandler
7	5	UserFolder
8	5	GroupFolder
9	5	OrganisationUnitFolder
10	5	DataEntity
11	5	DataUserData
12	5	File
13	5	Value
14	5	ImageCache
15	10	Equipment
16	10	EquipmentType
17	3	Item
18	7	Manufacturer
19	2	OrganisationUnit
20	8	Project
21	8	ProjectPermission
22	8	ProjectLog
23	8	ProjectItem
24	8	ProjectLogHasItem
25	8	ProjectTask
26	8	ProjectVirtualFolder
27	8	ProjectUserData
28	8	ProjectItemFactory
29	8	ProjectExtension
30	9	Sample
31	9	SampleSecurity
32	9	SampleItem
33	9	SampleVirtualFolder
34	9	SampleItemFactory
\.


--
-- TOC entry 3075 (class 0 OID 159374)
-- Dependencies: 168
-- Data for Name: core_base_include_files; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_include_files (id, include_id, name, checksum) FROM stdin;
1	1	db_table_name.php	aed016f89aed1b949fa94770cabbf5b9
2	1	class_event_listener.php	2f813058f511f883fa73f8bf0aed9ac7
3	5	db_table_name.php	1e57495f2b153339102c5cb18614c6f1
4	5	class_event_listener.php	0ac22a13fda8a6f8528df68e67d2a11f
5	5	class_path.php	8e59a703292c86db596108291737e4f0
6	10	db_table_name.php	832e17ec7d405976e1155715fd49165f
7	10	class_event_listener.php	3cce4503f8152f3d7ff60f9eaf029e95
8	10	class_path.php	d7b90027c9ac40011f33f191f01b906d
9	3	db_table_name.php	b0e440ec7ec22b4037b45dbf14cb5554
10	3	class_event_listener.php	361a98bed1c379996b18b9777fa7c8f2
11	3	class_path.php	157e921f00852e0d5b0dd464ebe70879
12	6	db_table_name.php	5d3f68ba8f57321cc9acd603a3c267db
13	6	class_path.php	88f828e824e6f3bd767c6dd6f2df84c8
14	7	db_table_name.php	4683d9f2290badebdca215344e161604
15	7	class_event_listener.php	9a7be6c4198a1317c4639ba9c260916d
16	7	class_path.php	5a388c4af403054795ab5d5f70b0466e
17	2	db_table_name.php	070ec9c5226a2dae7381810b9acb8896
18	2	class_event_listener.php	63fd49d54b8003d7e12a6ccdcb32e569
19	2	class_path.php	fdbab10500a1b507169c61cbb7164d4d
20	11	include_info.php	46c798638e1b54d3b3615a027fbd0be5
21	11	class_path.php	431b9f77b1b68529541fcde976b55fcf
22	8	db_table_name.php	b38558d38e4eb88ab0cc6b6606ef2126
23	8	class_event_listener.php	13623052ead2f10b731c51bf8ccc8d39
24	8	class_path.php	1a239b9e678ad95123eabc591f2b92ae
25	9	db_table_name.php	85757f9bf97f5def5072cc04222a6504
26	9	class_event_listener.php	1cc8e360e7dd072fc6aa5cfb104860fe
27	9	class_path.php	922514bbd2d86cdcd7c9e8f4096f2892
28	4	db_table_name.php	7a679c858302eb81752c38cab4b1e444
29	4	class_path.php	e2175b6f7d266f0aec8e638ed8e78f51
30	5	register_execute.php	b3cf7da38c449889c97e556b7f6a0501
31	8	register_execute.php	341c518b33d543457289996974114b9c
32	9	register_execute.php	35e5427acaf81225c3d22001cd97b277
33	10	register_execute.php	829b57eac64bf7ad5beee8694a688d60
\.


--
-- TOC entry 3076 (class 0 OID 159385)
-- Dependencies: 170
-- Data for Name: core_base_include_functions; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_include_functions (id, include, function_name, db_version) FROM stdin;
37	base	concat	\N
38	base	nameconcat	\N
46	organisation_unit	get_organisation_unit_childs	\N
92	data	get_all_file_versions	\N
93	data	get_all_value_versions	\N
94	data	search_get_sub_folders	\N
119	project	get_project_id_by_folder_id	\N
120	project	get_project_supplementary_folder	\N
121	project	project_permission_group	\N
122	project	project_permission_organisation_unit	\N
123	project	project_permission_user	\N
124	project	search_get_project_subprojects	\N
135	sample	get_sample_id_by_folder_id	\N
\.


--
-- TOC entry 3077 (class 0 OID 159396)
-- Dependencies: 172
-- Data for Name: core_base_include_tables; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_include_tables (id, include, table_name, db_version) FROM stdin;
1	base	core_base_batch_runs	\N
2	base	core_base_batch_types	\N
3	base	core_base_event_listeners	\N
4	base	core_base_include_files	\N
5	base	core_base_include_functions	\N
6	base	core_base_include_tables	\N
7	base	core_base_includes	\N
8	base	core_base_measuring_unit_categories	\N
9	base	core_base_measuring_unit_ratios	\N
10	base	core_base_measuring_units	\N
11	base	core_base_module_dialogs	\N
12	base	core_base_module_files	\N
13	base	core_base_module_links	\N
14	base	core_base_module_navigation	\N
15	base	core_base_modules	\N
16	base	core_base_registry	\N
17	base	core_binaries	\N
18	base	core_countries	\N
19	base	core_currencies	\N
20	base	core_extensions	\N
21	base	core_group_has_users	\N
22	base	core_groups	\N
23	base	core_languages	\N
24	base	core_paper_sizes	\N
25	base	core_service_has_log_entries	\N
26	base	core_services	\N
27	base	core_session_values	\N
28	base	core_sessions	\N
29	base	core_system_log	\N
30	base	core_system_log_types	\N
31	base	core_system_messages	\N
32	base	core_timezones	\N
33	base	core_user_admin_settings	\N
34	base	core_user_profiles	\N
35	base	core_user_regional_settings	\N
36	base	core_users	\N
39	organisation_unit	core_organisation_unit_has_groups	\N
40	organisation_unit	core_organisation_unit_has_leaders	\N
41	organisation_unit	core_organisation_unit_has_members	\N
42	organisation_unit	core_organisation_unit_has_owners	\N
43	organisation_unit	core_organisation_unit_has_quality_managers	\N
44	organisation_unit	core_organisation_unit_types	\N
45	organisation_unit	core_organisation_units	\N
47	item	core_item_class_has_item_information	\N
48	item	core_item_classes	\N
49	item	core_item_concretion	\N
50	item	core_item_has_item_classes	\N
51	item	core_item_has_item_information	\N
52	item	core_item_holders	\N
53	item	core_item_information	\N
54	item	core_items	\N
55	template	core_oldl_templates	\N
56	template	core_olvdl_templates	\N
57	template	core_xml_cache	\N
58	template	core_xml_cache_elements	\N
59	data	core_data_entities	\N
60	data	core_data_entity_has_data_entities	\N
61	data	core_data_entity_is_item	\N
62	data	core_data_parameter_field_has_methods	\N
63	data	core_data_parameter_field_limits	\N
64	data	core_data_parameter_field_values	\N
65	data	core_data_parameter_fields	\N
66	data	core_data_parameter_has_non_template	\N
67	data	core_data_parameter_has_template	\N
68	data	core_data_parameter_limits	\N
69	data	core_data_parameter_methods	\N
70	data	core_data_parameter_non_template_has_fields	\N
71	data	core_data_parameter_non_templates	\N
72	data	core_data_parameter_template_has_fields	\N
73	data	core_data_parameter_templates	\N
74	data	core_data_parameter_versions	\N
75	data	core_data_parameters	\N
76	data	core_data_user_data	\N
77	data	core_file_image_cache	\N
78	data	core_file_version_blobs	\N
79	data	core_file_versions	\N
80	data	core_files	\N
81	data	core_folder_concretion	\N
82	data	core_folder_is_group_folder	\N
83	data	core_folder_is_organisation_unit_folder	\N
84	data	core_folder_is_system_folder	\N
85	data	core_folder_is_user_folder	\N
86	data	core_folders	\N
87	data	core_value_types	\N
88	data	core_value_var_cases	\N
89	data	core_value_versions	\N
90	data	core_values	\N
91	data	core_virtual_folders	\N
95	location	core_location_types	\N
96	location	core_locations	\N
97	manufacturer	core_manufacturers	\N
98	project	core_project_has_extension_runs	\N
99	project	core_project_has_folder	\N
100	project	core_project_has_items	\N
101	project	core_project_has_project_status	\N
102	project	core_project_links	\N
103	project	core_project_log	\N
104	project	core_project_log_has_items	\N
105	project	core_project_log_has_project_status	\N
106	project	core_project_permissions	\N
107	project	core_project_status	\N
108	project	core_project_status_has_folder	\N
109	project	core_project_task_has_previous_tasks	\N
110	project	core_project_task_milestones	\N
111	project	core_project_task_processes	\N
112	project	core_project_task_status_processes	\N
113	project	core_project_tasks	\N
114	project	core_project_template_cats	\N
115	project	core_project_templates	\N
116	project	core_project_user_data	\N
117	project	core_projects	\N
118	project	core_virtual_folder_is_project	\N
125	sample	core_sample_has_folder	\N
126	sample	core_sample_has_items	\N
127	sample	core_sample_has_locations	\N
128	sample	core_sample_has_organisation_units	\N
129	sample	core_sample_has_users	\N
130	sample	core_sample_is_item	\N
131	sample	core_sample_template_cats	\N
132	sample	core_sample_templates	\N
133	sample	core_samples	\N
134	sample	core_virtual_folder_is_sample	\N
136	equipment	core_equipment	\N
137	equipment	core_equipment_cats	\N
138	equipment	core_equipment_has_organisation_units	\N
139	equipment	core_equipment_has_responsible_persons	\N
140	equipment	core_equipment_is_item	\N
141	equipment	core_equipment_types	\N
\.


--
-- TOC entry 3078 (class 0 OID 159407)
-- Dependencies: 174
-- Data for Name: core_base_includes; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_includes (id, name, folder, db_version) FROM stdin;
1	base	base	0.4.0.0
2	organisation_unit	organisation_unit	0.4.0.0
3	item	item	0.4.0.0
4	template	template	0.4.0.0
5	data	data	0.4.0.0
6	location	location	0.4.0.0
7	manufacturer	manufacturer	0.4.0.0
8	project	project	0.4.0.0
9	sample	sample	0.4.0.0
10	equipment	equipment	0.4.0.0
11	parser	parser	\N
\.


--
-- TOC entry 3079 (class 0 OID 159418)
-- Dependencies: 176
-- Data for Name: core_base_measuring_unit_categories; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_measuring_unit_categories (id, name, created_by_user) FROM stdin;
1	Lenght	f
2	Mass	f
3	Time	f
4	Electric Current	f
5	Temperature	f
6	Amount of Substance	f
7	Luminous Intensity	f
8	Angle	f
9	Area	f
10	Volume	f
11	Force	f
12	Pressure	f
13	Voltage	f
14	Electric Resistance	f
15	Electric Conductance	f
16	Electric Charge	f
17	Electric Capacitance	f
18	Frequency	f
19	Amount	f
20	Percent/Per Mill	f
\.


--
-- TOC entry 3080 (class 0 OID 159429)
-- Dependencies: 178
-- Data for Name: core_base_measuring_unit_ratios; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_measuring_unit_ratios (id, numerator_unit_id, numerator_unit_exponent, denominator_unit_id, denominator_unit_exponent) FROM stdin;
1	29	\N	24	-6
2	30	\N	24	-6
3	7	\N	26	\N
\.


--
-- TOC entry 3081 (class 0 OID 159437)
-- Dependencies: 180
-- Data for Name: core_base_measuring_units; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_measuring_units (id, base_id, category_id, name, unit_symbol, min_value, max_value, min_prefix_exponent, max_prefix_exponent, prefix_calculation_exponent, calculation, type, created_by_user) FROM stdin;
2	\N	1	meter	m	\N	\N	12	3	1	B	metric	f
4	2	1	foot	ft	\N	\N	\N	\N	1	B[div]0.3048	aa	f
5	2	1	yard	yd	\N	\N	\N	\N	1	B[div]0.9144	aa	f
6	2	1	mile	Mi	\N	\N	\N	\N	1	B[div]1609.344	aa	f
3	2	1	inch	in	\N	\N	\N	\N	1	B[div]0.0254	aa	f
1	\N	\N	pH-Value	pH (-lg(aH))	0	14	\N	\N	\N	\N	\N	f
7	\N	2	gramm	g	\N	\N	12	3	\N	B	metric	f
8	\N	3	second	s	\N	\N	12	\N	\N	B	\N	f
10	\N	5	kelvin	K	\N	\N	\N	\N	\N	B	\N	f
13	\N	8	radiant	rad	\N	\N	\N	\N	\N	B	\N	f
17	\N	12	pascal	Pa	\N	\N	12	3	\N	B	metric	f
18	\N	13	volt	V	\N	\N	12	3	\N	B	\N	f
20	\N	15	siemens	S	\N	\N	\N	\N	\N	B	\N	f
21	\N	16	coulomb	C	\N	\N	\N	\N	\N	B	\N	f
22	\N	17	farad	F	\N	\N	12	9	\N	B	\N	f
23	\N	18	hertz	Hz	\N	\N	12	12	\N	B	\N	f
9	\N	4	ampere	A	\N	\N	12	3	\N	B	\N	f
11	\N	6	mol	mol	\N	\N	12	3	\N	B	\N	f
12	\N	7	candela	cd	\N	\N	12	3	\N	B	\N	f
16	\N	11	newton	N	\N	\N	12	3	\N	B	\N	f
19	\N	14	ohm	&Omega;	\N	\N	12	9	\N	B	\N	f
14	\N	9	square meter	m2	\N	\N	12	3	2	B	metric	f
15	\N	10	cubic meter	m3	\N	\N	12	3	3	B	metric	f
26	15	10	deciliter	dl	\N	\N	\N	\N	\N	B[mul]10000	metric	f
24	15	10	liter	l	\N	\N	18	\N	\N	B[mul]1000	metric	f
25	\N	19	amount	#	\N	\N	\N	\N	\N	B	\N	f
27	\N	20	percent	%	\N	\N	\N	\N	\N	B	\N	f
28	\N	20	per mill	&#8240;	\N	\N	\N	\N	\N	B[div]10	\N	f
29	25	19	thousand	thous	\N	\N	\N	\N	\N	B[mul]1000	\N	f
30	25	19	million	mil	\N	\N	\N	\N	\N	B[mul]1000000	\N	f
\.


--
-- TOC entry 3082 (class 0 OID 159448)
-- Dependencies: 182
-- Data for Name: core_base_module_dialogs; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_module_dialogs (id, module_id, dialog_type, class_path, class, method, internal_name, language_address, weight, disabled) FROM stdin;
1	1	standard_navigation	core/modules/base/io/navigation/left_navigation.io.php	LeftNavigationIO	create_left_navigation	navigation	\N	\N	f
2	1	search	core/modules/base/io/user_search.io.php	UserSearchIO	search	user_search	BaseDialogUserSearch	500	f
3	1	common_dialog	core/modules/base/io/user.io.php	UserIO	user_details	user_detail	\N	\N	f
4	1	common_dialog	core/modules/base/io/user.io.php	UserIO	group_details	group_detail	\N	\N	f
5	1	organisation_admin	core/modules/base/io/admin/admin_user.io.php	AdminUserIO	handler	users	BaseDialogAdminMenuUser	100	f
6	1	organisation_admin	core/modules/base/io/admin/admin_group.io.php	AdminGroupIO	handler	groups	BaseDialogAdminMenuGroup	200	f
7	1	admin_home_box	core/modules/base/io/admin/admin_user.io.php	AdminUserIO	home_dialog	users	\N	200	f
8	1	admin_home_box	core/modules/base/io/admin/admin_group.io.php	AdminGroupIO	home_dialog	groups	\N	300	f
9	1	base_user_lists	core/modules/base/io/batch.io.php	BatchIO	list_batches	list_batches	BaseDialogBatchTopMenuUserList	\N	f
10	2	item_list	core/modules/data/data.request.php	DataRequest	io_handler	data	DataDialogItemDataList	300	f
11	2	item_add	core/modules/data/io/value.io.php	ValueIO	add_value_item	value	\N	\N	f
12	2	item_add	core/modules/data/io/file.io.php	FileIO	upload_as_item	file	\N	\N	f
13	2	search	core/modules/data/io/data_search.io.php	DataSearchIO	search	ffv_search	DataDialogFFVSearch	600	f
14	2	module_admin	core/modules/data/io/admin/admin_value_template.io.php	AdminValueTemplateIO	handler	value_template	DataDialogAdminMenuValueTemplates	100	f
15	2	admin_home_box	core/modules/data/io/admin/admin_data.io.php	AdminDataIO	home_dialog	data	\N	100	f
16	2	user_module_detail_setting	core/modules/data/io/data.io.php	DataIO	get_user_module_detail_setting	user_quota	DataDialogModuleDetailUserQuota	100	f
17	2	module_value_change	core/modules/data/io/data.io.php	DataIO	change_quota	user_quota	DataDialogModuleValueChangeUserQuota	\N	f
18	2	common_dialog	core/modules/data/io/file.io.php	FileIO	upload	file_add	\N	\N	f
19	2	base_left_navigation	core/modules/data/io/navigation/data_navigation.io.php	DataNavigationIO	get_html	data	DataDialogLeftNavigation	400	f
20	2	item_report	core/modules/data/report/data_report.io.php	DataReportIO	get_data_item_report	data_item_report	\N	100	f
21	2	item_assistant_list	core/modules/data/io/file.io.php	FileIO	list_file_items	data	\N	100	f
22	2	home_summary_left	core/modules/data/io/data_home.io.php	DataHomeIO	quota	data	\N	300	f
23	2	home_summary_right	core/modules/data/io/data_home.io.php	DataHomeIO	used_diskspace	data	\N	300	f
24	2	item_edit	core/modules/data/io/value.io.php	ValueIO	edit_value_item	value	\N	\N	f
25	2	standard_search	core/modules/data/io/data_search.io.php	DataSearchIO	search	ffv_search	\N	\N	f
26	2	module_admin	core/modules/data/io/admin/admin_parameter_template.io.php	AdminParameterTemplateIO	handler	parameter_template	DataDialogAdminMenuParameterTemplates	200	f
27	2	module_admin	core/modules/data/io/admin/admin_parameter_method.io.php	AdminParameterMethodIO	handler	parameter_method	DataDialogAdminMenuParameterMethods	200	f
28	2	item_add	core/modules/data/io/parameter.io.php	ParameterIO	add_parameter_item	parameter	\N	\N	f
29	2	item_edit	core/modules/data/io/parameter.io.php	ParameterIO	edit_parameter_item	parameter	\N	\N	f
30	3	item_list	core/modules/equipment/io/equipment.io.php	EquipmentIO	list_equipment_item_handler	equipment	EquipmentDialogItemEquipmentList	200	f
31	3	module_admin	core/modules/equipment/io/admin/admin_equipment_cat.io.php	AdminEquipmentCatIO	handler	equipment_cat	EquipmentDialogAdminMenuCat	10000	f
32	3	module_admin	core/modules/equipment/io/admin/admin_equipment_type.io.php	AdminEquipmentTypeIO	handler	equipment_type	EquipmentDialogAdminMenuTypes	10100	f
33	3	common_dialog	core/modules/equipment/io/equipment.io.php	EquipmentIO	list_organisation_unit_related_equipment_handler	list_ou_equipment	\N	\N	f
34	3	item_report	core/modules/equipment/report/equipment_report.io.php	EquipmentReportIO	get_equipment_item_report	equipment_item_report	\N	500	f
35	3	item_assistant_list	core/modules/equipment/io/equipment.io.php	EquipmentIO	list_equipment_items	equipment	\N	200	f
36	4	search	core/modules/item/io/item_fulltext_search.io.php	ItemFulltextSearchIO	search	item_fulltext_search	ItemDialogFulltextSearch	700	f
37	5	module_admin	core/modules/location/io/admin/admin_location.io.php	AdminLocationIO	handler	locations	LocationDialogAdminMenuLocation	20000	f
38	6	common_dialog	core/modules/manufacturer/io/manufacturer.io.php	ManufacturerIO	list_manufacturers	list_manufacturers	\N	\N	f
39	7	organisation_admin	core/modules/organisation_unit/io/admin/admin_organisation_unit.io.php	AdminOrganisationUnitIO	handler	organisation_units	OrganisationUnitDialogAdminMenuOU	300	f
40	7	admin_home_box	core/modules/organisation_unit/io/admin/admin_organisation_unit.io.php	AdminOrganisationUnitIO	home_dialog	organisation_units	\N	400	f
41	7	base_left_navigation	core/modules/organisation_unit/io/navigation/organisation_unit_navigation.io.php	OrganisationUnitNavigationIO	get_html	organisation_units	OrganisationUnitDialogLeftNavigation	200	f
42	7	common_dialog	core/modules/organisation_unit/io/organisation_unit.io.php	OrganisationUnitIO	detail_handler	ou_detail	\N	\N	f
43	7	base_user_lists	core/modules/organisation_unit/io/organisation_unit.io.php	OrganisationUnitIO	list_user_related_organisation_units	my_organisation_units	OrganisationUnitTopMenuUserList	\N	f
44	7	user_admin_detail	core/modules/organisation_unit/io/organisation_unit.io.php	OrganisationUnitIO	list_user_admin_organisation_units	organisation_units	OrganisationUnitAdminUserTab	\N	f
45	7	group_admin_detail	core/modules/organisation_unit/io/organisation_unit.io.php	OrganisationUnitIO	list_group_admin_organisation_units	organisation_units	OrganisationUnitAdminGroupTab	\N	f
46	8	home_today_box	core/modules/organiser/io/organiser.io.php	OrganiserIO	list_upcoming_appointments	personal_appointments	\N	200	f
47	8	home_today_box	core/modules/organiser/io/organiser.io.php	OrganiserIO	list_upcoming_tasks	todo	\N	300	f
48	9	parent_item_list	core/modules/project/io/project.io.php	ProjectIO	list_projects_by_item_id	project	ProjectDialogParentItemProjectList	100	f
49	9	search	core/modules/project/io/project_search.io.php	ProjectSearchIO	search	project_search	ProjectDialogProjectSearch	100	f
50	9	search	core/modules/project/io/project_data_search.io.php	ProjectDataSearchIO	search	project_data_search	ProjectDialogProjectDataSearch	300	f
51	9	module_admin	core/modules/project/io/admin/admin_project_status.io.php	AdminProjectStatusIO	handler	project_status	ProjectDialogAdminMenuProjectStatus	1000	f
52	9	module_admin	core/modules/project/io/admin/admin_project_template_cat.io.php	AdminProjectTemplateCatIO	handler	Project_template_cat	ProjectDialogAdminMenuProjectTemplateCat	1100	f
53	9	module_admin	core/modules/project/io/admin/admin_project_template.io.php	AdminProjectTemplateIO	handler	project_template	ProjectDialogAdminMenuProjectTemplate	1200	f
54	9	user_module_detail_setting	core/modules/project/io/project_data.io.php	ProjectDataIO	get_user_module_detail_setting	project_quota	ProjectDialogModuleDetailProjectQuota	200	f
55	9	module_value_change	core/modules/project/io/project_data.io.php	ProjectDataIO	change	project_quota	ProjectDialogModuleValueProjectQuota	\N	f
56	9	additional_quota	core/modules/project/io/project_data.io.php	ProjectDataIO	get_used_project_space	project_quota	ProjectDialogAdditionalQuota	100	f
57	9	home_today_box	core/modules/project/io/project_task.io.php	ProjectTaskIO	list_upcoming_tasks	project_tasks	\N	100	f
58	9	base_left_navigation	core/modules/project/io/navigation/project_navigation.io.php	ProjectNavigationIO	get_html	projects	ProjectDialogLeftNavigation	300	f
59	9	item_parent_assistant_list	core/modules/project/io/project.io.php	ProjectIO	list_projects_by_item_id	project	\N	100	f
60	9	home_summary_left	core/modules/project/io/project_home.io.php	ProjectHomeIO	running_projects	project	\N	100	f
61	9	home_summary_left	core/modules/project/io/project_home.io.php	ProjectHomeIO	finished_projects	project	\N	200	f
62	9	standard_search	core/modules/project/io/project_search.io.php	ProjectSearchIO	search	project_search	\N	\N	f
63	10	item_list	core/modules/sample/io/sample.io.php	SampleIO	list_sample_items	sample	SampleDialogItemSampleList	100	f
64	10	item_add	core/modules/sample/io/sample.io.php	SampleIO	add_sample_item	sample	\N	\N	f
65	10	item_add	core/modules/sample/io/sample.io.php	SampleIO	add_sample_item	parentsample	\N	\N	f
66	10	module_admin	core/modules/sample/io/admin/admin_sample_template_cat.io.php	AdminSampleTemplateCatIO	handler	sample_template_cat	SampleDialogAdminMenuSampleTemplateCat	2100	f
67	10	module_admin	core/modules/sample/io/admin/admin_sample_template.io.php	AdminSampleTemplateIO	handler	sample_template	SampleDialogAdminMenuSampleTemplate	2200	f
68	10	search	core/modules/sample/io/sample_search.io.php	SampleSearchIO	search	sample_search	SampleDialogSampleSearch	200	f
69	10	search	core/modules/sample/io/sample_data_search.io.php	SampleDataSearchIO	search	sample_data_search	SampleDialogSampleDataSearch	400	f
70	10	parent_item_list	core/modules/sample/io/sample.io.php	SampleIO	list_samples_by_item_id	sample	SampleDialogPartentItemSampleList	200	f
71	10	report	core/modules/sample/report/sample_report.io.php	SampleReportIO	get_full_report	sample_full_report	\N	\N	f
72	10	report	core/modules/sample/report/sample_report.io.php	SampleReportIO	get_barcode_report	sample_barcode_report	\N	\N	f
73	10	item_report	core/modules/sample/report/sample_report.io.php	SampleReportIO	get_sample_item_report	sample_item_report	\N	1000	f
74	10	item_assistant_list	core/modules/sample/io/sample.io.php	SampleIO	list_sample_items	sample	\N	300	f
75	10	item_parent_assistant_list	core/modules/sample/io/sample.io.php	SampleIO	list_samples_by_item_id	sample	\N	200	f
76	10	home_summary_right	core/modules/sample/io/sample_home.io.php	SampleHomeIO	samples	sample	\N	100	f
77	10	home_summary_right	core/modules/sample/io/sample_home.io.php	SampleHomeIO	empty_space	sample	\N	200	f
78	10	standard_search	core/modules/sample/io/sample_search.io.php	SampleSearchIO	search	sample_search	\N	\N	f
\.


--
-- TOC entry 3083 (class 0 OID 159459)
-- Dependencies: 184
-- Data for Name: core_base_module_files; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_module_files (id, module_id, name, checksum) FROM stdin;
1	1	module_info.php	efc07e1aed50e6029f2b5b2be164e611
2	1	module_dialogs.php	bcc2fdf8fe6386904901fffa69dff388
3	2	module_info.php	5ab62b612ba8e75360383ee117289286
4	2	module_dialogs.php	1592afcfd7357d3b1570856ceada53cb
5	2	module_link.php	63889ad5ef3525d4caf24508595b114a
6	3	module_info.php	e38ce41ea4574eda068b487e3d0c4161
7	3	module_dialogs.php	6126351151ff31d0481215298c00db1e
8	3	module_link.php	4fb646654b36fc9eeb78d1655dcfc457
9	4	module_info.php	70a92cd9b992e0639b2b256a6fbf699a
10	4	module_dialogs.php	6890b8973e2c3c8b3ce83e621be3dc29
11	5	module_info.php	55450dea2dd2a33c62a304cafcd0fefa
12	5	module_dialogs.php	535ac4e135558a59d08a07673e7ab9fb
13	6	module_info.php	2890bf45737a5e51d4ebc39a01a29aa7
14	6	module_dialogs.php	33bb8adda35c19895d64669a699b4128
15	7	module_info.php	7959c346accefe67d2d105aa6f1baa25
16	7	module_dialogs.php	7f9ad73956f887aae7188b65ea58704b
17	7	module_link.php	c0862d2c67b9ddcee283c7bb7020695d
18	8	module_info.php	0b9b5526e0e5a993388ee7b2c7d8fc3a
19	8	module_dialogs.php	9455408382a9b8975e8a380ea2d577ff
20	9	module_info.php	4ebc668ad1fd88939b1231ee44e385ee
21	9	module_dialogs.php	31186231fd61989bb36358a2ccf6ff21
22	9	module_link.php	949c5577a3dc123be40d51d328e39d60
23	10	module_info.php	82ffa995d401654b8bca5594d4fb7db3
24	10	module_dialogs.php	8bd6f8021df61e6ad42000f50a74a59c
25	10	module_link.php	5fb3cb170b2f6328e0ebb6f6dd909bf4
\.


--
-- TOC entry 3084 (class 0 OID 159470)
-- Dependencies: 186
-- Data for Name: core_base_module_links; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_module_links (id, module_id, link_type, link_array, link_file, weight, disabled) FROM stdin;
1	2	home_button	a:1:{s:3:"nav";s:4:"data";}	data/home/buttons/view_my_files.html	500	f
2	3	ou_detail_buttons	a:4:{s:3:"nav";s:5:"%NAV%";s:3:"run";s:13:"common_dialog";s:6:"dialog";s:17:"list_ou_equipment";s:5:"ou_id";s:7:"%OU_ID%";}	equipment/links/lab_equipment.html	200	f
3	7	home_button	a:2:{s:3:"nav";s:6:"static";s:3:"run";s:7:"myorgan";}	organisation_unit/home/buttons/get_to_my.html	600	f
4	9	home_button	a:2:{s:3:"nav";s:7:"project";s:3:"run";s:3:"new";}	project/home/buttons/create.html	100	f
5	9	home_button	a:1:{s:3:"nav";s:7:"project";}	project/home/buttons/view_my.html	200	f
6	9	ou_navigation	a:3:{s:3:"nav";s:7:"project";s:3:"run";s:10:"organ_unit";s:5:"ou_id";s:7:"%OU_ID%";}	\N	0	f
7	10	home_button	a:2:{s:3:"nav";s:6:"sample";s:3:"run";s:3:"new";}	sample/home/buttons/create.html	300	f
8	10	home_button	a:1:{s:3:"nav";s:6:"sample";}	sample/home/buttons/view_my.html	400	f
9	10	ou_navigation	a:3:{s:3:"nav";s:6:"sample";s:3:"run";s:10:"organ_unit";s:5:"ou_id";s:7:"%OU_ID%";}	\N	100	f
\.


--
-- TOC entry 3085 (class 0 OID 159481)
-- Dependencies: 188
-- Data for Name: core_base_module_navigation; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_module_navigation (id, language_address, "position", colour, module_id, hidden, alias, controller_class, controller_file) FROM stdin;
1	BaseMainHome	2	blue	1	f	\N	BaseRequest	base.request.php
2	BaseMainSearch	3	orange	1	f	search	BaseRequest	base.request.php
3	BaseMainAdmin	4	grey	1	f	admin	AdminRequest	admin.request.php
4	BaseMainExtensions	5	blue	1	f	extension	ExtensionRequest	extension.request.php
5	DataMainData	6	green	2	f	\N	DataRequest	data.request.php
6	ProjectMainProjects	7	green	9	f	\N	ProjectRequest	project.request.php
7	SampleMainSamples	8	orange	10	f	\N	SampleRequest	sample.request.php
\.


--
-- TOC entry 3086 (class 0 OID 159494)
-- Dependencies: 190
-- Data for Name: core_base_modules; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_modules (id, name, folder, class, disabled) FROM stdin;
1	base	base	BaseRequest	f
2	data	data	DataRequest	f
3	equipment	equipment	EquipmentRequest	f
4	item	item	ItemRequest	f
5	location	location	LocationIO	f
6	manufacturer	manufacturer	ManufacturerRequest	f
7	organisation_unit	organisation_unit	OrganisationUnitRequest	f
8	organiser	organiser	OrganiserRequest	f
9	project	project	ProjectRequest	f
10	sample	sample	SampleRequest	f
\.


--
-- TOC entry 3087 (class 0 OID 159505)
-- Dependencies: 192
-- Data for Name: core_base_registry; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_base_registry (id, name, include_id, value) FROM stdin;
1	base_timezone_id	1	26
2	base_os	1	win
3	base_product_user	1	John Doe
4	base_product_function	1	test server
5	base_html_title	1	Open-LIMS
6	base_update_check	1	false
7	base_update_check_url	1	http://update.open-lims.org/check.php
8	base_session_timeout	1	36000
9	base_max_ip_failed_logins	1	10
10	base_max_ip_lead_time	1	36000
13	base_cron_last_run_daily_id	1	1
14	base_cron_last_run_weekly_id	1	1
15	base_java_vm	1	java
16	data_user_default_quota	5	53687091200
17	data_quota_warning	5	90
18	data_max_cached_images	5	100000
19	data_max_cache_period	5	30
20	project_user_default_quota	8	1073741824
21	project_user_default_permission	8	15
22	project_leader_default_permission	8	51
23	project_quality_manager_default_permission	8	1
24	project_group_default_permission	8	1
25	project_organisation_unit_default_permission	8	1
26	sample_default_expiry_warning	9	7
12	base_cron_last_run_id	1	2
11	base_cron_last_run_datetime	1	2014-01-20 13:47:55
\.


--
-- TOC entry 3088 (class 0 OID 159518)
-- Dependencies: 194
-- Data for Name: core_binaries; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_binaries (id, path, file) FROM stdin;
\.


--
-- TOC entry 3089 (class 0 OID 159529)
-- Dependencies: 196
-- Data for Name: core_countries; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_countries (id, english_name, local_name, iso_3166) FROM stdin;
1	Afghanistan	Afghanestan	AF
2	Egypt	Misr	EG
3	Albania	Shqiperia	AL
4	Algeria	Al Jaza'ir	DZ
5	Andorra	Andorra	AD
6	Angola	Angola	AO
7	Antigua and Barbuda	Antigua and Barbuda	AG
8	Equatorial Guinea	Guinea Ecuatorial	GQ
9	Argentina	Argentina	AR
10	Armenia	Hayastan	AM
11	Azerbaijan	Azarbaycan	AZ
12	Ethiopia	Ityop'iya	ET
13	Australia	Australia	AU
14	Bahamas	Bahamas	BS
15	Bahrain	Al Bahrayn	BH
16	Bangladesh	Bangladesh	BD
17	Barbados	Barbados	BB
18	Belgium	Belgique/Belgie	BE
19	Belize	Belize	BZ
20	Benin	Benin	BJ
21	Bhutan	Bhutan	BT
22	Bolivia	Bolivia	BO
23	Bosnia and Herzegovina	Bosna i Hercegovina	BA
24	Botswana	Botswana	BW
25	Brazil	Brasil	BR
26	Brunei Darussalam	Negara Brunei Darussalam	BN
27	Bulgaria	Bulgaria	BG
28	Burkina Faso	Burkina Faso	BF
29	Burundi	Burundi	BI
30	Chile	Chile	CL
31	Taiwan (Republic of China)	T'ai-wan	TW
32	China	Zhong Guo	CN
33	Cook Islands	Cook Islands	CK
34	Costa Rica	Costa Rica	CR
35	Denmark	Danmark	DK
36	Germany	Deutschland	DE
37	Dominica	Dominica	DM
38	Dominican Republic	Dominicana, Republica	DO
39	Djibouti	Djibouti	DJ
40	Ecuador	Ecuador	EC
41	El Salvador	El Salvador	SV
42	Ivory Coast	Cote d'Ivoire	CI
43	Eritrea	Hagere Ertra	ER
44	Estonia	Eesti Vabariik	EE
45	Fiji	Fiji	FJ
46	Finland	Suomen Tasavalta	FI
47	France	France	FR
48	Gabon	Gabon	GA
49	Gambia	The Gambia	GM
50	Georgia	Sak'art'velo	GE
51	Ghana	Ghana	GH
52	Grenada	Grenada	GD
53	Greece	Ellas or Ellada	GR
54	Guatemala	Guatemala	GT
55	Guinea	Guinee	GN
56	Guinea-Bissau	Guine-Bissau	GW
57	Guyana	Guyana	GY
58	Haiti	Haiti	HT
59	Honduras	Honduras	HN
60	India	Bharat	IN
61	Indonesia	Indonesia	ID
62	Iraq	Iraq	IQ
63	Iran	Iran	IR
64	Ireland	ire	IE
65	Iceland	Lyoveldio Island	IS
66	Israel	Yisra'el	IL
67	Italy	Italia	IT
68	Jamaica	Jamaica	JM
69	Japan	Nippon, Nihon	JP
70	Yemen	Al Yaman	YE
71	Jordan	Al Urdun	JO
72	Cambodia	Kampuchea	KH
73	Cameroon	Cameroon	CM
74	Canada	Canada	CA
75	Cape Verde	Cabo Verde	CV
76	Kazakhstan	Qazaqstan	KZ
77	Qatar	Dawlat Qatar	QA
78	Kenya	Kenya	KE
79	Kyrgyzstan	Kyrgyz Respublikasy	KG
80	Kiribati	Kiribati, (Kiribas)	KI
81	Colombia	Colombia	CO
82	Comoros	Comores	KM
83	Democratic Republic of the Congo (Kinshasa)	Republique Democratique du Congo	CD
84	Republic of Congo (Brazzaville)	Republique du Congo	CG
85	North Korea	Choson	KP
86	South Korea	Han-guk	KR
87	Croatia	Hrvatska	HR
88	Cuba	Cuba	CU
89	Kuwait	Al Kuwayt	KW
90	Lao	Lao	LA
91	Lesotho	Lesotho	LS
92	Latvia	Latvija	LV
93	Lebanon	Lubnan	LB
94	Liberia	Liberia	LR
95	Libya	Libiyah	LY
96	Liechtenstein	Liechtenstein	LI
97	Lithuania	Lietuva	LT
98	Luxembourg	Luxembourg/Letzebuerg	LU
99	Madagascar	Madagascar	MG
100	Malawi	Malawi	MW
101	Malaysia	Malaysia	MY
102	Maldives	Dhivehi Raajje	MV
103	Mali	Mali	ML
104	Malta	Malta	MT
105	Morocco	Al Maghrib	MA
106	Marshall Islands	Marshall Islands	MH
107	Mauritania	Muritaniyah	MR
108	Mauritius	Mauritius	MU
109	Macedonia, Rep. of	Makedonija	MK
110	Mexico	Estados Unidos Mexicanos	MX
111	Micronesia	Micronesia	FM
112	Moldova	Moldova	MD
113	Monaco	Monaco	MC
114	Mongolia	Mongol Uls	MN
115	Montenegro	Crna Gora	ME
116	Mozambique	Mocambique	MZ
117	Myanmar, Burma	Myanma Naingngandaw	MM
118	Namibia	Namibia	NA
119	Nauru	Nauru	NR
120	Nepal	Nepal	NP
121	New Zealand	Aotearoa	NZ
122	Nicaragua	Nicaragua	NI
123	Netherlands	Nederland	NL
124	Niger	Niger	NE
125	Nigeria	Nigeria	NG
126	Niue	Niue	NU
127	Norway	Norge	NO
128	Oman	Saltanat Uman	OM
129	Austria	™sterreich	AT
130	East Timor	Timor	TL
131	Pakistan	Pakistan	PK
132	Palestine	Dawlat Filastin	PS
133	Palau	Belau	PW
134	Panama	Panama	PA
135	Papua New Guinea	Papua Niu Gini	PG
136	Paraguay	Paraguay	PY
137	Peru	Peru	PE
138	Philippines	Pilipinas	PH
139	Poland	Polska	PL
140	Portugal	Portugal	PT
141	Rwanda	Rwanda	RW
142	Romania	Romania	RO
143	Russian Federation	Rossiya	RU
144	Solomon Islands	Solomon Islands	SB
145	Zambia	Zambia	ZM
146	Samoa	Samoa	WS
147	San Marino	San Marino	SM
148	Sao Tome and Pr­ncipe	Sao Tome e Principe	ST
149	Saudi Arabia	Al Arabiyah as Suudiyah	SA
150	Sweden	Sverige	SE
151	Switzerland	Schweiz/Suisse/Svizzera	CH
152	Senegal	Senegal	SN
153	Serbia	Srbija	RS
154	Seychelles	Seychelles	SC
155	Sierra Leone	Sierra Leone	SL
156	Zimbabwe	Zimbabwe	ZW
157	Singapore	Singapore	SG
158	Slovakia	Slovensko	SK
159	Slovenia	Slovenija	SI
160	Somalia	Somalia	SO
161	Spain	Espana	ES
162	Sri Lanka	Sri Lanka	LK
163	Saint Kitts and Nevis	Saint Kitts and Nevis	KN
164	Saint Lucia	Saint Lucia	LC
165	Saint Vincent and the Grenadines	Saint Vincent and the Grenadines	VC
166	South Africa	South Africa	ZA
167	Sudan	As-Sudan	SD
168	Suriname	Suriname	SR
169	Swaziland	Swaziland	SZ
170	Syria, Syrian Arab Republic	Suriyah	SY
171	Tajikistan	Jumhurii Tojikiston	TJ
172	Tanzania	Tanzania	TZ
173	Thailand	Prathet Thai	TH
174	Togo	Republique Togolaise	TG
175	Tonga	Tonga	TO
176	Trinidad and Tobago	Trinidad, Tobago	TT
177	Chad	Tchad	TD
178	Czech Republic	Ceska Republika	CZ
179	Tunisia	Tunis	TN
180	Turkey	Turkiye	TR
181	Turkmenistan	Turkmenistan	TM
182	Tuvalu	Tuvalu	TV
183	Uganda	Uganda	UG
184	Ukraine	Ukrayina	UA
185	Hungary	Magyarorszag	HU
186	Uruguay	Republica Oriental del Uruguay	UY
187	Uzbekistan	Uzbekiston Respublikasi	UZ
188	Vanuatu	Vanuatu	VU
189	Vatican City	Status Civitatis Vatican	VA
190	Venezuela	Venezuela	VE
191	United Arab Emirates	Al Imarat al Arabiyah al Muttahidah	AE
192	United States	United States	US
193	United Kingdom	United Kingdom	GB
194	Vietnam	Viet Nam	VN
195	Belarus	Byelarus	BY
196	Western Sahara	Western Sahara	EH
197	Central African Republic	Republique Centrafricaine	CF
198	Cyprus	Kibris/Kypros	CY
\.


--
-- TOC entry 3090 (class 0 OID 159540)
-- Dependencies: 198
-- Data for Name: core_currencies; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_currencies (id, name, symbol, iso_4217) FROM stdin;
1	Euro		EUR
2	US-Dollar		USD
\.


--
-- TOC entry 3127 (class 0 OID 160156)
-- Dependencies: 262
-- Data for Name: core_data_entities; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_entities (id, datetime, owner_id, owner_group_id, permission, automatic) FROM stdin;
1	2011-01-01 08:00:00+01	1	\N	\N	t
3	2011-01-01 08:00:00+01	1	\N	\N	t
6	2011-01-01 08:00:00+01	1	\N	\N	t
7	2011-01-01 08:00:00+01	1	\N	\N	t
8	2011-01-01 08:00:00+01	1	\N	\N	t
9	2011-01-01 08:00:00+01	1	\N	\N	t
51	2011-01-01 08:00:00+01	1	\N	\N	t
52	2011-01-01 08:00:00+01	1	\N	\N	t
101	2011-01-01 08:00:00+01	1	1	\N	t
102	2011-01-01 08:00:00+01	1	2	\N	t
109	2011-01-01 08:00:00+01	1	9	\N	t
110	2011-01-01 08:00:00+01	1	10	\N	t
111	2011-01-01 08:00:00+01	1	11	\N	t
10000	2011-01-01 08:00:00+01	1	\N	\N	t
10001	2011-01-01 08:00:00+01	1	\N	\N	t
10002	2011-01-01 08:00:00+01	1	\N	\N	t
4	2011-01-01 08:00:00+01	1	\N	\N	t
10004	2011-01-01 08:00:00+01	1	\N	\N	t
10005	2011-01-01 08:00:00+01	1	\N	\N	t
10006	2011-01-01 08:00:00+01	1	\N	\N	t
10007	2011-01-01 08:00:00+01	1	\N	\N	t
10008	2011-01-01 08:00:00+01	1	\N	\N	t
10009	2011-01-01 08:00:00+01	1	\N	\N	t
5	2011-01-01 08:00:00+01	1	\N	\N	t
10010	2011-01-01 08:00:00+01	1	\N	\N	t
10011	2011-01-01 08:00:00+01	1	\N	\N	t
10012	2011-01-01 08:00:00+01	1	\N	\N	t
10013	2011-01-01 08:00:00+01	1	\N	\N	t
10014	2011-01-01 08:00:00+01	1	\N	\N	t
10015	2011-01-01 08:00:00+01	1	\N	\N	t
\.


--
-- TOC entry 3128 (class 0 OID 160162)
-- Dependencies: 263
-- Data for Name: core_data_entity_has_data_entities; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_entity_has_data_entities (data_entity_pid, data_entity_cid, link, link_item_id) FROM stdin;
1	3	\N	\N
1	6	\N	\N
1	7	\N	\N
1	8	\N	\N
1	9	\N	\N
7	51	\N	\N
7	52	\N	\N
9	101	\N	\N
9	102	\N	\N
9	109	\N	\N
9	110	\N	\N
9	111	\N	\N
8	10000	\N	\N
10000	10001	\N	\N
10000	10002	\N	\N
1	4	\N	\N
10000	10004	\N	\N
101	10005	\N	\N
102	10006	\N	\N
109	10007	\N	\N
110	10008	\N	\N
111	10009	\N	\N
1	5	\N	\N
10000	10010	\N	\N
101	10011	\N	\N
102	10012	\N	\N
109	10013	\N	\N
110	10014	\N	\N
111	10015	\N	\N
\.


--
-- TOC entry 3129 (class 0 OID 160167)
-- Dependencies: 264
-- Data for Name: core_data_entity_is_item; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_entity_is_item (data_entity_id, item_id) FROM stdin;
1	1
3	3
6	6
7	7
8	8
9	9
51	51
52	52
101	101
102	102
109	109
110	110
111	111
10000	10000
10001	10001
10002	10002
4	4
10004	10004
10005	10005
10006	10006
10007	10007
10008	10008
10009	10009
5	5
10010	10010
10011	10011
10012	10012
10013	10013
10014	10014
10015	10015
\.


--
-- TOC entry 3130 (class 0 OID 160174)
-- Dependencies: 265
-- Data for Name: core_data_parameter_field_has_methods; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_field_has_methods (parameter_field_id, parameter_method_id) FROM stdin;
\.


--
-- TOC entry 3131 (class 0 OID 160179)
-- Dependencies: 266
-- Data for Name: core_data_parameter_field_limits; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_field_limits (parameter_limit_id, parameter_field_id, upper_specification_limit, lower_specification_limit) FROM stdin;
1	1	11.1	3.8999999999999999
1	2	5.7000000000000002	4.2000000000000002
1	3	16.899999999999999	13.199999999999999
1	4	49	38.5
1	5	97	80
1	6	33.5	27.5
1	7	36	32
1	8	15	11
1	9	390	140
1	10	11.5	7.5
2	11	80	38
2	12	49	15
2	13	13	0
2	14	8	0
2	15	2	0
2	16	8	1.6000000000000001
2	17	3.5	1
2	18	0.90000000000000002	0.040000000000000001
2	19	0.59999999999999998	0.029999999999999999
2	20	0.125	0
\.


--
-- TOC entry 3132 (class 0 OID 160186)
-- Dependencies: 268
-- Data for Name: core_data_parameter_field_values; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_field_values (id, parameter_version_id, parameter_field_id, parameter_method_id, value, source, locked) FROM stdin;
\.


--
-- TOC entry 3133 (class 0 OID 160197)
-- Dependencies: 270
-- Data for Name: core_data_parameter_fields; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_fields (id, name, min_value, max_value, measuring_unit_id, measuring_unit_exponent, measuring_unit_ratio_id) FROM stdin;
1	WBC	0	\N	\N	\N	1
2	RBC	0	\N	\N	\N	2
3	HGB	0	\N	\N	\N	3
4	HCT	0	100	27	0	\N
5	MCV	0	\N	24	-15	\N
6	MCH	0	\N	7	-12	\N
7	MCHC	0	\N	\N	\N	3
8	RDW	0	100	27	0	\N
9	Plt	0	\N	\N	\N	1
10	MPV	0	\N	24	-15	\N
11	NE%	0	100	27	0	\N
12	LY%	0	100	27	0	\N
13	MO%	0	100	27	0	\N
14	EO%	0	100	27	0	\N
15	BA%	0	100	27	0	\N
16	NE#	0	\N	\N	\N	1
17	LY#	0	\N	\N	\N	1
18	MO#	0	\N	\N	\N	1
19	EO#	0	\N	\N	\N	1
20	BA#	0	\N	\N	\N	1
\.


--
-- TOC entry 3134 (class 0 OID 160206)
-- Dependencies: 271
-- Data for Name: core_data_parameter_has_non_template; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_has_non_template (parameter_id, non_template_id) FROM stdin;
\.


--
-- TOC entry 3135 (class 0 OID 160213)
-- Dependencies: 272
-- Data for Name: core_data_parameter_has_template; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_has_template (parameter_id, template_id) FROM stdin;
\.


--
-- TOC entry 3136 (class 0 OID 160222)
-- Dependencies: 274
-- Data for Name: core_data_parameter_limits; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_limits (id, name) FROM stdin;
1	First Limit
2	First Limit
\.


--
-- TOC entry 3137 (class 0 OID 160233)
-- Dependencies: 276
-- Data for Name: core_data_parameter_methods; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_methods (id, name) FROM stdin;
1	Counting
\.


--
-- TOC entry 3138 (class 0 OID 160242)
-- Dependencies: 277
-- Data for Name: core_data_parameter_non_template_has_fields; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_non_template_has_fields (non_template_id, parameter_field_id) FROM stdin;
\.


--
-- TOC entry 3139 (class 0 OID 160249)
-- Dependencies: 279
-- Data for Name: core_data_parameter_non_templates; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_non_templates (id, datetime) FROM stdin;
\.


--
-- TOC entry 3140 (class 0 OID 160255)
-- Dependencies: 280
-- Data for Name: core_data_parameter_template_has_fields; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_template_has_fields (template_id, parameter_field_id, "position") FROM stdin;
1	1	\N
1	2	\N
1	3	\N
1	4	\N
1	5	\N
1	6	\N
1	7	\N
1	8	\N
1	9	\N
1	10	\N
2	11	\N
2	12	\N
2	13	\N
2	14	\N
2	15	\N
2	16	\N
2	17	\N
2	18	\N
2	19	\N
2	20	\N
\.


--
-- TOC entry 3141 (class 0 OID 160262)
-- Dependencies: 282
-- Data for Name: core_data_parameter_templates; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_templates (id, internal_name, name, created_by, datetime) FROM stdin;
1	BC	Blood Count	1	2011-01-01 08:00:00+01
2	DBC	Differential Blood Count	1	2011-01-01 08:00:00+01
\.


--
-- TOC entry 3142 (class 0 OID 160275)
-- Dependencies: 284
-- Data for Name: core_data_parameter_versions; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameter_versions (id, parameter_id, version, internal_revision, previous_version_id, current, owner_id, datetime, name, parameter_limit_id) FROM stdin;
\.


--
-- TOC entry 3143 (class 0 OID 160286)
-- Dependencies: 286
-- Data for Name: core_data_parameters; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_parameters (id, data_entity_id) FROM stdin;
\.


--
-- TOC entry 3144 (class 0 OID 160292)
-- Dependencies: 287
-- Data for Name: core_data_user_data; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_data_user_data (user_id, quota, filesize) FROM stdin;
1	\N	0
\.


--
-- TOC entry 3194 (class 0 OID 161354)
-- Dependencies: 369
-- Data for Name: core_equipment; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_equipment (id, type_id, owner_id, datetime) FROM stdin;
\.


--
-- TOC entry 3195 (class 0 OID 161362)
-- Dependencies: 371
-- Data for Name: core_equipment_cats; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_equipment_cats (id, toid, name) FROM stdin;
1	1	other
1000	1	Hardware
1001	1	Software
\.


--
-- TOC entry 3196 (class 0 OID 161371)
-- Dependencies: 372
-- Data for Name: core_equipment_has_organisation_units; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_equipment_has_organisation_units (equipment_id, organisation_unit_id) FROM stdin;
\.


--
-- TOC entry 3197 (class 0 OID 161376)
-- Dependencies: 373
-- Data for Name: core_equipment_has_responsible_persons; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_equipment_has_responsible_persons (equipment_id, user_id) FROM stdin;
\.


--
-- TOC entry 3198 (class 0 OID 161381)
-- Dependencies: 374
-- Data for Name: core_equipment_is_item; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_equipment_is_item (equipment_id, item_id) FROM stdin;
\.


--
-- TOC entry 3199 (class 0 OID 161390)
-- Dependencies: 376
-- Data for Name: core_equipment_types; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_equipment_types (id, toid, name, cat_id, location_id, description, manufacturer) FROM stdin;
1	1	manual	1	\N	\N	\N
2	2	external	1	\N	\N	\N
3	3	other	1	\N	\N	\N
\.


--
-- TOC entry 3091 (class 0 OID 159551)
-- Dependencies: 200
-- Data for Name: core_extensions; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_extensions (id, name, identifier, folder, class, main_file, version) FROM stdin;
\.


--
-- TOC entry 3145 (class 0 OID 160299)
-- Dependencies: 289
-- Data for Name: core_file_image_cache; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_file_image_cache (id, file_version_id, width, height, size, last_access) FROM stdin;
\.


--
-- TOC entry 3146 (class 0 OID 160305)
-- Dependencies: 290
-- Data for Name: core_file_version_blobs; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_file_version_blobs (file_version_id, blob) FROM stdin;
\.


--
-- TOC entry 3147 (class 0 OID 160315)
-- Dependencies: 292
-- Data for Name: core_file_versions; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_file_versions (id, toid, name, version, size, checksum, datetime, comment, previous_version_id, internal_revision, current, file_extension, owner_id) FROM stdin;
\.


--
-- TOC entry 3148 (class 0 OID 160328)
-- Dependencies: 294
-- Data for Name: core_files; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_files (id, data_entity_id, flag) FROM stdin;
\.


--
-- TOC entry 3149 (class 0 OID 160336)
-- Dependencies: 296
-- Data for Name: core_folder_concretion; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_folder_concretion (id, type, handling_class, include_id) FROM stdin;
1	system_folder	SystemFolder	5
2	user_folder	UserFolder	5
3	group_folder	GroupFolder	5
4	organisation_unit_folder	OrganisationUnitFolder	5
5	project_folder	ProjectFolder	8
6	project_status_folder	ProjectStatusFolder	8
7	sample_folder	SampleFolder	9
\.


--
-- TOC entry 3150 (class 0 OID 160345)
-- Dependencies: 297
-- Data for Name: core_folder_is_group_folder; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_folder_is_group_folder (group_id, folder_id) FROM stdin;
1	101
2	102
9	109
10	110
11	111
\.


--
-- TOC entry 3151 (class 0 OID 160350)
-- Dependencies: 298
-- Data for Name: core_folder_is_organisation_unit_folder; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_folder_is_organisation_unit_folder (organisation_unit_id, folder_id) FROM stdin;
\.


--
-- TOC entry 3152 (class 0 OID 160355)
-- Dependencies: 299
-- Data for Name: core_folder_is_system_folder; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_folder_is_system_folder (folder_id) FROM stdin;
1
3
6
7
8
9
4
5
\.


--
-- TOC entry 3153 (class 0 OID 160360)
-- Dependencies: 300
-- Data for Name: core_folder_is_user_folder; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_folder_is_user_folder (user_id, folder_id) FROM stdin;
1	10000
\.


--
-- TOC entry 3154 (class 0 OID 160367)
-- Dependencies: 302
-- Data for Name: core_folders; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_folders (id, data_entity_id, name, path, deleted, blob, flag) FROM stdin;
1	1		filesystem	f	f	\N
3	3	organisation_units	filesystem/organisation_units	f	f	\N
6	6	temp	filesystem/temp	f	f	\N
7	7	templates	filesystem/templates	f	f	\N
8	8	users	filesystem/users	f	f	\N
9	9	groups	filesystem/groups	f	f	\N
51	51	OLDL	filesystem/templates/OLDL	f	f	\N
52	52	OLVDL	filesystem/templates/OLVDL	f	f	\N
101	101	Administrators	filesystem/groups/1	f	f	\N
102	102	Member-Administrators	filesystem/groups/2	f	f	\N
109	109	Group-Leaders	filesystem/groups/9	f	f	\N
110	110	Users	filesystem/groups/10	f	f	\N
111	111	Quality-Managers	filesystem/groups/11	f	f	\N
10000	10000	system	filesystem/users/1	f	f	\N
10001	10001	_private	filesystem/users/1/_private	f	f	\N
10002	10002	_public	filesystem/users/1/_public	f	f	\N
4	4	projects	filesystem/projects	f	f	\N
5	5	samples	filesystem/samples	f	f	\N
\.


--
-- TOC entry 3092 (class 0 OID 159564)
-- Dependencies: 202
-- Data for Name: core_group_has_users; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_group_has_users (primary_key, group_id, user_id) FROM stdin;
1	1	1
2	10	1
\.


--
-- TOC entry 3093 (class 0 OID 159572)
-- Dependencies: 204
-- Data for Name: core_groups; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_groups (id, name) FROM stdin;
1	Administrators
2	Member-Administrators
10	Users
9	Group-Leaders
11	Quality-Managers
\.


--
-- TOC entry 3115 (class 0 OID 159995)
-- Dependencies: 238
-- Data for Name: core_item_class_has_item_information; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_item_class_has_item_information (primary_key, item_class_id, item_information_id) FROM stdin;
\.


--
-- TOC entry 3116 (class 0 OID 160003)
-- Dependencies: 240
-- Data for Name: core_item_classes; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_item_classes (id, name, datetime, owner_id, colour) FROM stdin;
\.


--
-- TOC entry 3117 (class 0 OID 160014)
-- Dependencies: 242
-- Data for Name: core_item_concretion; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_item_concretion (id, type, handling_class, include_id) FROM stdin;
1	file	DataEntity	5
2	value	DataEntity	5
3	parameter	DataEntity	5
4	sample	Sample	9
5	parentsample	Sample	9
6	equipment	Equipment	10
\.


--
-- TOC entry 3118 (class 0 OID 160025)
-- Dependencies: 244
-- Data for Name: core_item_has_item_classes; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_item_has_item_classes (primary_key, item_id, item_class_id) FROM stdin;
\.


--
-- TOC entry 3119 (class 0 OID 160033)
-- Dependencies: 246
-- Data for Name: core_item_has_item_information; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_item_has_item_information (primary_key, item_id, item_information_id) FROM stdin;
\.


--
-- TOC entry 3120 (class 0 OID 160041)
-- Dependencies: 248
-- Data for Name: core_item_holders; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_item_holders (id, name, handling_class, include_id) FROM stdin;
1	project	Project	8
2	sample	Sample	9
\.


--
-- TOC entry 3121 (class 0 OID 160052)
-- Dependencies: 250
-- Data for Name: core_item_information; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_item_information (id, description, keywords, last_update, description_text_search_vector, keywords_text_search_vector, language_id) FROM stdin;
\.


--
-- TOC entry 3122 (class 0 OID 160063)
-- Dependencies: 252
-- Data for Name: core_items; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_items (id, datetime) FROM stdin;
1	2011-01-01 08:00:00+01
3	2011-01-01 08:00:00+01
6	2011-01-01 08:00:00+01
7	2011-01-01 08:00:00+01
8	2011-01-01 08:00:00+01
9	2011-01-01 08:00:00+01
51	2011-01-01 08:00:00+01
52	2011-01-01 08:00:00+01
101	2011-01-01 08:00:00+01
102	2011-01-01 08:00:00+01
109	2011-01-01 08:00:00+01
110	2011-01-01 08:00:00+01
111	2011-01-01 08:00:00+01
10000	2011-01-01 08:00:00+01
10001	2011-01-01 08:00:00+01
10002	2011-01-01 08:00:00+01
4	2011-01-01 08:00:00+01
10004	2011-01-01 08:00:00+01
10005	2011-01-01 08:00:00+01
10006	2011-01-01 08:00:00+01
10007	2011-01-01 08:00:00+01
10008	2011-01-01 08:00:00+01
10009	2011-01-01 08:00:00+01
5	2011-01-01 08:00:00+01
10010	2011-01-01 08:00:00+01
10011	2011-01-01 08:00:00+01
10012	2011-01-01 08:00:00+01
10013	2011-01-01 08:00:00+01
10014	2011-01-01 08:00:00+01
10015	2011-01-01 08:00:00+01
\.


--
-- TOC entry 3094 (class 0 OID 159583)
-- Dependencies: 206
-- Data for Name: core_languages; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_languages (id, english_name, language_name, tsvector_name, iso_639, iso_3166) FROM stdin;
1	English	English	english	en	GB
\.


--
-- TOC entry 3160 (class 0 OID 160731)
-- Dependencies: 314
-- Data for Name: core_location_types; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_location_types (id, name) FROM stdin;
1	Building
2	Floor
3	Room
4	Lab
5	Freezer
6	Refrigerator
7	Deep Freezer
8	Ice-chest
9	Cold-room
\.


--
-- TOC entry 3161 (class 0 OID 160742)
-- Dependencies: 316
-- Data for Name: core_locations; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_locations (id, toid, type_id, name, additional_name, prefix) FROM stdin;
\.


--
-- TOC entry 3162 (class 0 OID 160763)
-- Dependencies: 318
-- Data for Name: core_manufacturers; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_manufacturers (id, name, user_id, datetime) FROM stdin;
\.


--
-- TOC entry 3123 (class 0 OID 160118)
-- Dependencies: 254
-- Data for Name: core_oldl_templates; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_oldl_templates (id, data_entity_id) FROM stdin;
\.


--
-- TOC entry 3124 (class 0 OID 160126)
-- Dependencies: 256
-- Data for Name: core_olvdl_templates; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_olvdl_templates (id, data_entity_id) FROM stdin;
\.


--
-- TOC entry 3114 (class 0 OID 159926)
-- Dependencies: 236
-- Data for Name: core_organisation_unit_has_groups; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_organisation_unit_has_groups (organisation_unit_id, group_id) FROM stdin;
\.


--
-- TOC entry 3113 (class 0 OID 159921)
-- Dependencies: 235
-- Data for Name: core_organisation_unit_has_leaders; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_organisation_unit_has_leaders (organisation_unit_id, leader_id) FROM stdin;
\.


--
-- TOC entry 3112 (class 0 OID 159916)
-- Dependencies: 234
-- Data for Name: core_organisation_unit_has_members; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_organisation_unit_has_members (organisation_unit_id, member_id) FROM stdin;
\.


--
-- TOC entry 3111 (class 0 OID 159911)
-- Dependencies: 233
-- Data for Name: core_organisation_unit_has_owners; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_organisation_unit_has_owners (organisation_unit_id, owner_id, master_owner) FROM stdin;
\.


--
-- TOC entry 3110 (class 0 OID 159906)
-- Dependencies: 232
-- Data for Name: core_organisation_unit_has_quality_managers; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_organisation_unit_has_quality_managers (organisation_unit_id, quality_manager_id) FROM stdin;
\.


--
-- TOC entry 3108 (class 0 OID 159886)
-- Dependencies: 229
-- Data for Name: core_organisation_unit_types; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_organisation_unit_types (id, name, icon) FROM stdin;
1	root	root.png
2	institute	institutes.png
3	lab-group	ou_groups.png
\.


--
-- TOC entry 3109 (class 0 OID 159897)
-- Dependencies: 231
-- Data for Name: core_organisation_units; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_organisation_units (id, toid, is_root, name, type_id, stores_data, "position", hidden) FROM stdin;
\.


--
-- TOC entry 3095 (class 0 OID 159594)
-- Dependencies: 208
-- Data for Name: core_paper_sizes; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_paper_sizes (id, name, width, height, margin_left, margin_right, margin_top, margin_bottom, base, standard) FROM stdin;
2	A1	594	841	10	10	10	10	t	f
3	A2	420	594	10	10	10	10	t	f
4	A3	297	420	10	10	10	10	t	f
5	A4	210	297	10	10	10	10	t	t
6	A5	148	210	10	10	10	10	t	f
7	A6	105	148	10	10	10	10	t	f
8	Invoice	140	216	10	10	10	10	t	f
9	Executive	184	267	10	10	10	10	t	f
10	Legal	216	356	10	10	10	10	t	f
11	Letter	216	279	10	10	10	10	t	f
12	Ledger	279	432	10	10	10	10	t	f
13	Broadsheet	432	559	10	10	10	10	t	f
1	A0	841	1189	10	10	10	10	t	f
\.


--
-- TOC entry 3163 (class 0 OID 160780)
-- Dependencies: 320
-- Data for Name: core_project_has_extension_runs; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_has_extension_runs (primary_key, project_id, extension_id, run) FROM stdin;
\.


--
-- TOC entry 3164 (class 0 OID 160786)
-- Dependencies: 321
-- Data for Name: core_project_has_folder; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_has_folder (project_id, folder_id) FROM stdin;
\.


--
-- TOC entry 3165 (class 0 OID 160793)
-- Dependencies: 323
-- Data for Name: core_project_has_items; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_has_items (primary_key, project_id, item_id, active, required, gid, project_status_id, parent_item_id) FROM stdin;
\.


--
-- TOC entry 3166 (class 0 OID 160801)
-- Dependencies: 325
-- Data for Name: core_project_has_project_status; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_has_project_status (primary_key, project_id, status_id, datetime, current) FROM stdin;
\.


--
-- TOC entry 3167 (class 0 OID 160809)
-- Dependencies: 327
-- Data for Name: core_project_links; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_links (primary_key, to_project_id, project_id) FROM stdin;
\.


--
-- TOC entry 3168 (class 0 OID 160817)
-- Dependencies: 329
-- Data for Name: core_project_log; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_log (id, project_id, datetime, content, cancel, important, owner_id) FROM stdin;
\.


--
-- TOC entry 3169 (class 0 OID 160828)
-- Dependencies: 331
-- Data for Name: core_project_log_has_items; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_log_has_items (primary_key, project_log_id, item_id) FROM stdin;
\.


--
-- TOC entry 3170 (class 0 OID 160836)
-- Dependencies: 333
-- Data for Name: core_project_log_has_project_status; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_log_has_project_status (primary_key, log_id, status_id) FROM stdin;
\.


--
-- TOC entry 3171 (class 0 OID 160846)
-- Dependencies: 335
-- Data for Name: core_project_permissions; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_permissions (id, user_id, organisation_unit_id, group_id, project_id, permission, owner_id, intention) FROM stdin;
\.


--
-- TOC entry 3172 (class 0 OID 160854)
-- Dependencies: 337
-- Data for Name: core_project_status; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_status (id, name, analysis, blocked, comment) FROM stdin;
0	canceled	f	f	\N
1	creating	f	f	\N
2	finished	f	f	\N
100	in progress	f	f	\N
10001	RNA	f	f	\N
10002	MicroArray	f	f	\N
10003	cDNA	f	f	\N
10004	hybridisation	f	f	\N
10005	washing	f	f	\N
10006	scanning	f	f	\N
10007	spotfinding	f	f	\N
10008	manual curation	f	f	\N
10009	analysis	t	f	\N
20001	sample description	f	f	\N
20002	specify experiment	f	f	\N
20003	import data	f	f	\N
\.


--
-- TOC entry 3173 (class 0 OID 160863)
-- Dependencies: 338
-- Data for Name: core_project_status_has_folder; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_status_has_folder (project_id, project_status_id, folder_id) FROM stdin;
\.


--
-- TOC entry 3174 (class 0 OID 160868)
-- Dependencies: 339
-- Data for Name: core_project_task_has_previous_tasks; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_task_has_previous_tasks (task_id, previous_task_id) FROM stdin;
\.


--
-- TOC entry 3175 (class 0 OID 160873)
-- Dependencies: 340
-- Data for Name: core_project_task_milestones; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_task_milestones (task_id, name) FROM stdin;
\.


--
-- TOC entry 3176 (class 0 OID 160881)
-- Dependencies: 341
-- Data for Name: core_project_task_processes; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_task_processes (task_id, name, progress) FROM stdin;
\.


--
-- TOC entry 3177 (class 0 OID 160889)
-- Dependencies: 342
-- Data for Name: core_project_task_status_processes; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_task_status_processes (task_id, begin_status_id, end_status_id, finalise, subtraction_points) FROM stdin;
\.


--
-- TOC entry 3178 (class 0 OID 160896)
-- Dependencies: 344
-- Data for Name: core_project_tasks; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_tasks (id, type_id, project_id, owner_id, comment, start_date, start_time, end_date, end_time, whole_day, auto_connect, finished, created_at, finished_at, over_time) FROM stdin;
\.


--
-- TOC entry 3179 (class 0 OID 160907)
-- Dependencies: 346
-- Data for Name: core_project_template_cats; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_template_cats (id, name) FROM stdin;
1	General
2	MicroArray
3	Microscopy
\.


--
-- TOC entry 3180 (class 0 OID 160916)
-- Dependencies: 347
-- Data for Name: core_project_templates; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_templates (id, name, cat_id, parent_template, template_id) FROM stdin;
\.


--
-- TOC entry 3181 (class 0 OID 160924)
-- Dependencies: 348
-- Data for Name: core_project_user_data; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_project_user_data (user_id, quota) FROM stdin;
\.


--
-- TOC entry 3182 (class 0 OID 160931)
-- Dependencies: 350
-- Data for Name: core_projects; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_projects (id, toid_organ_unit, toid_project, datetime, name, owner_id, template_id, quota, filesize, deleted) FROM stdin;
\.


--
-- TOC entry 3184 (class 0 OID 161164)
-- Dependencies: 352
-- Data for Name: core_sample_has_folder; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_has_folder (sample_id, folder_id) FROM stdin;
\.


--
-- TOC entry 3185 (class 0 OID 161171)
-- Dependencies: 354
-- Data for Name: core_sample_has_items; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_has_items (primary_key, sample_id, item_id, gid, parent, parent_item_id) FROM stdin;
\.


--
-- TOC entry 3186 (class 0 OID 161179)
-- Dependencies: 356
-- Data for Name: core_sample_has_locations; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_has_locations (primary_key, sample_id, location_id, datetime, user_id) FROM stdin;
\.


--
-- TOC entry 3187 (class 0 OID 161187)
-- Dependencies: 358
-- Data for Name: core_sample_has_organisation_units; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_has_organisation_units (primary_key, sample_id, organisation_unit_id) FROM stdin;
\.


--
-- TOC entry 3188 (class 0 OID 161195)
-- Dependencies: 360
-- Data for Name: core_sample_has_users; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_has_users (primary_key, sample_id, user_id, read, write) FROM stdin;
\.


--
-- TOC entry 3189 (class 0 OID 161201)
-- Dependencies: 361
-- Data for Name: core_sample_is_item; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_is_item (sample_id, item_id) FROM stdin;
\.


--
-- TOC entry 3190 (class 0 OID 161210)
-- Dependencies: 363
-- Data for Name: core_sample_template_cats; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_template_cats (id, name) FROM stdin;
1	General
2	MicroArray
3	Microscopy
4	RNA
\.


--
-- TOC entry 3191 (class 0 OID 161219)
-- Dependencies: 364
-- Data for Name: core_sample_templates; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sample_templates (id, name, cat_id, template_id) FROM stdin;
\.


--
-- TOC entry 3192 (class 0 OID 161229)
-- Dependencies: 366
-- Data for Name: core_samples; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_samples (id, name, datetime, owner_id, template_id, available, deleted, comment, comment_text_search_vector, language_id, date_of_expiry, expiry_warning, manufacturer_id) FROM stdin;
\.


--
-- TOC entry 3096 (class 0 OID 159603)
-- Dependencies: 209
-- Data for Name: core_service_has_log_entries; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_service_has_log_entries (service_id, log_entry_id) FROM stdin;
\.


--
-- TOC entry 3097 (class 0 OID 159610)
-- Dependencies: 211
-- Data for Name: core_services; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_services (id, name, binary_id, status, last_lifesign) FROM stdin;
\.


--
-- TOC entry 3098 (class 0 OID 159621)
-- Dependencies: 213
-- Data for Name: core_session_values; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_session_values (id, session_id, address, value) FROM stdin;
\.


--
-- TOC entry 3099 (class 0 OID 159632)
-- Dependencies: 214
-- Data for Name: core_sessions; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_sessions (session_id, ip, user_id, datetime) FROM stdin;
\.


--
-- TOC entry 3100 (class 0 OID 159642)
-- Dependencies: 216
-- Data for Name: core_system_log; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_system_log (id, type_id, user_id, datetime, ip, content_int, content_string, content_errorno, file, line, link, stack_trace) FROM stdin;
\.


--
-- TOC entry 3101 (class 0 OID 159653)
-- Dependencies: 218
-- Data for Name: core_system_log_types; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_system_log_types (id, name) FROM stdin;
1	Security Notices
2	Open-LIMS Errors
3	PHP Errors
4	Deleted Objects
\.


--
-- TOC entry 3102 (class 0 OID 159664)
-- Dependencies: 220
-- Data for Name: core_system_messages; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_system_messages (id, user_id, datetime, content) FROM stdin;
\.


--
-- TOC entry 3103 (class 0 OID 159675)
-- Dependencies: 222
-- Data for Name: core_timezones; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_timezones (id, title, php_title, deviation) FROM stdin;
1	Midway Islands, Samoa	Pacific/Samoa	-11
2	Hawaii, Polynesia	US/Hawaii	-10
3	Alaska	US/Alaska	-9
4	Tijuana, Los Angeles, Seattle, Vancouver	America/Los_Angeles	-8
5	Arizona	US/Arizona	-7
6	Chihuahua, La Paz, Mazatlan	America/Chihuahua	-7
7	Arizona, Denver, Salt Lake City, Calgary	America/Denver	-7
8	Chicago, Dallas, Kansas City, Winnipeg	America/Chicago	-6
9	Guadalajara, Mexico City, Monterrey	America/Monterrey	-6
10	Saskatchewan	Canada/Saskatchewan	-6
11	Central America	US/Central	-6
12	Bogota, Lima, Quito	America/Bogota	-5
13	East-Indiana	US/East-Indiana	-5
14	New York, Miami, Atlanta, Detroit, Toronto	America/New_York	-5
15	Atlantic (Canada)	Canada/Atlantic	-4
16	Carcas, La Paz	America/La_Paz	-4
17	Santiago	America/Santiago	-4
18	Newfoundland	Canada/Newfoundland	-3
19	Sao Paulo	Brazil/East	-3
20	Buenes Aires, Georgtown	America/Argentina/Buenos_Aires	-3
21	Greenland, Uruguay, Surinam	GMT+3	-3
22	Cape Verde, Greenland, South Georgia	Atlantic/Cape_Verde	-2
23	Azores	Atlantic/Azores	-1
24	Casablanca, Monrovia	Africa/Casablanca	0
25	Dublin, Edinburgh, Lisbon, London	Europe/London	0
26	Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna	Europe/Berlin	1
27	Belgrade, Bratislava, Budapest, Ljubljana, Prague	Europe/Belgrade	1
28	Brussels, Copenhagen, Paris, Madrid	Europe/Paris	1
29	Sarajevo, Skopje, Warsaw, Zagreb	Europe/Sarajevo	1
30	West-Central Africa	Africa/Lagos	1
31	Athens, Beirut, Istanbul, Minsk	Europe/Athens	2
32	Bucharest	Europe/Bucharest	2
33	Harare, Pratoria	Africa/Harare	2
34	Helsinki, Kiev, Riga, Sofia, Tallinn, Vilnius	Europe/Helsinki	2
35	Jerusalem	Asia/Jerusalem	2
36	Cairo	Africa/Cairo	2
37	Baghdad	Asia/Baghdad	3
38	Kuwait, Riyadh	Asia/Kuwait	3
39	Moscow, Saint Petersburg	Europe/Moscow	3
40	Nairobi,Teheran	Africa/Nairobi	3
41	Abu Dhabi, Muscat	Asia/Muscat	4
42	Baku, Tbilisi, Erivan	Asia/Baku	4
43	Kabul	Asia/Kabul	4
44	Islamabad, Karachi, Taschkent	Asia/Karachi	5
45	Yekaterinburg, New Delhi	Asia/Yekaterinburg	5
46	Almaty, Novosibirsk, Kathmandu	Asia/Novosibirsk	6
47	Astana, Dhaka	Asia/Dhaka	6
48	Sri Jayawardenepura, Rangoon	Asia/Rangoon	6
49	Bangkok, Hanoi, Jakarta	Asia/Jakarta	7
50	Krasnoyarsk	Asia/Krasnoyarsk	7
51	Irkutsk, Ulan Bator	Asia/Irkutsk	8
52	Kuala Lumpour, Singapore	Asia/Singapore	8
53	Beijing, Chongqing, Hong kong, Urumchi	Asia/Hong_Kong	8
54	Perth	Australia/Perth	8
55	Taipei	Asia/Taipei	8
56	Yakutsk	Asia/Yakutsk	9
57	Osaka, Sapporo, Tokyo	Asia/Tokyo	9
58	Seoul, Darwin, Adelaide	Asia/Seoul	9
59	Brisbane	Australia/Brisbane	10
60	Canberra, Melbourne, Sydney	Australia/Sydney	10
61	Guam, Port Moresby	Pacific/Guam	10
62	Hobart	Australia/Hobart	10
63	Vladivostok	Asia/Vladivostok	10
64	Salomon Islands, New Caledonia, Magadan	Asia/Magadan	11
65	Auckland, Wellington	Pacific/Auckland	12
66	Fiji, Kamchatka, Marshall-Islands	Pacific/Fiji	12
67	Caracas	America/Caracas	-4.5
\.


--
-- TOC entry 3104 (class 0 OID 159684)
-- Dependencies: 223
-- Data for Name: core_user_admin_settings; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_user_admin_settings (id, can_change_password, must_change_password, user_locked, user_inactive, secure_password, last_password_change, block_write, create_folder) FROM stdin;
1	t	f	f	f	f	2008-01-01 12:00:00+01	f	f
\.


--
-- TOC entry 3105 (class 0 OID 159689)
-- Dependencies: 224
-- Data for Name: core_user_profiles; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_user_profiles (id, gender, title, forename, surname, mail, institution, department, street, zip, city, country, phone, icq, msn, yahoo, aim, skype, lync, jabber) FROM stdin;
1	\N		main	administrator		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 3106 (class 0 OID 159697)
-- Dependencies: 225
-- Data for Name: core_user_regional_settings; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_user_regional_settings (id, language_id, timezone_id, time_display_format, time_enter_format, date_display_format, date_enter_format, country_id, system_of_units, system_of_paper_format, currency_id, currency_significant_digits, decimal_separator, thousand_separator, name_display_format) FROM stdin;
1	1	26	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 3107 (class 0 OID 159707)
-- Dependencies: 227
-- Data for Name: core_users; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_users (id, username, password) FROM stdin;
1	system	096013f88fcf51a89f6d0c4e5285428e
\.


--
-- TOC entry 3155 (class 0 OID 160380)
-- Dependencies: 304
-- Data for Name: core_value_types; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_value_types (id, name, template_id) FROM stdin;
2	project description	\N
\.


--
-- TOC entry 3156 (class 0 OID 160391)
-- Dependencies: 306
-- Data for Name: core_value_var_cases; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_value_var_cases (id, name, handling_class, ignore_this, include_id) FROM stdin;
1	item	ItemValueVar	t	5
2	project	ProjectValueVar	f	8
3	sample	SampleValueVar	f	9
\.


--
-- TOC entry 3157 (class 0 OID 160402)
-- Dependencies: 308
-- Data for Name: core_value_versions; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_value_versions (id, toid, version, value, text_search_vector, checksum, datetime, language_id, previous_version_id, internal_revision, current, owner_id, name) FROM stdin;
\.


--
-- TOC entry 3158 (class 0 OID 160415)
-- Dependencies: 310
-- Data for Name: core_values; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_values (id, data_entity_id, type_id) FROM stdin;
\.


--
-- TOC entry 3183 (class 0 OID 160940)
-- Dependencies: 351
-- Data for Name: core_virtual_folder_is_project; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_virtual_folder_is_project (id) FROM stdin;
\.


--
-- TOC entry 3193 (class 0 OID 161238)
-- Dependencies: 367
-- Data for Name: core_virtual_folder_is_sample; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_virtual_folder_is_sample (id) FROM stdin;
\.


--
-- TOC entry 3159 (class 0 OID 160423)
-- Dependencies: 312
-- Data for Name: core_virtual_folders; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_virtual_folders (id, data_entity_id, name) FROM stdin;
1	10004	projects
2	10005	projects
3	10006	projects
4	10007	projects
5	10008	projects
6	10009	projects
7	10010	samples
8	10011	samples
9	10012	samples
10	10013	samples
11	10014	samples
12	10015	samples
\.


--
-- TOC entry 3125 (class 0 OID 160134)
-- Dependencies: 258
-- Data for Name: core_xml_cache; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_xml_cache (id, data_entity_id, path, checksum) FROM stdin;
\.


--
-- TOC entry 3126 (class 0 OID 160145)
-- Dependencies: 260
-- Data for Name: core_xml_cache_elements; Type: TABLE DATA; Schema: public; Owner: dbadmin
--

COPY core_xml_cache_elements (primary_key, toid, field_0, field_1, field_2, field_3) FROM stdin;
\.


--
-- TOC entry 2580 (class 2606 OID 159371)
-- Dependencies: 166 166
-- Name: core_base_event_listeners_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_event_listeners
    ADD CONSTRAINT core_base_event_listeners_pkey PRIMARY KEY (id);


--
-- TOC entry 2583 (class 2606 OID 159382)
-- Dependencies: 168 168
-- Name: core_base_include_files_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_include_files
    ADD CONSTRAINT core_base_include_files_pkey PRIMARY KEY (id);


--
-- TOC entry 2585 (class 2606 OID 159393)
-- Dependencies: 170 170
-- Name: core_base_include_functions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_include_functions
    ADD CONSTRAINT core_base_include_functions_pkey PRIMARY KEY (id);


--
-- TOC entry 2587 (class 2606 OID 159404)
-- Dependencies: 172 172
-- Name: core_base_include_tables_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_include_tables
    ADD CONSTRAINT core_base_include_tables_pkey PRIMARY KEY (id);


--
-- TOC entry 2589 (class 2606 OID 159415)
-- Dependencies: 174 174
-- Name: core_base_includes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_includes
    ADD CONSTRAINT core_base_includes_pkey PRIMARY KEY (id);


--
-- TOC entry 2593 (class 2606 OID 159434)
-- Dependencies: 178 178
-- Name: core_base_measuring_unit_ratios_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_measuring_unit_ratios
    ADD CONSTRAINT core_base_measuring_unit_ratios_pkey PRIMARY KEY (id);


--
-- TOC entry 2597 (class 2606 OID 159456)
-- Dependencies: 182 182
-- Name: core_base_module_dialogs_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_module_dialogs
    ADD CONSTRAINT core_base_module_dialogs_pkey PRIMARY KEY (id);


--
-- TOC entry 2600 (class 2606 OID 159467)
-- Dependencies: 184 184
-- Name: core_base_module_files_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_module_files
    ADD CONSTRAINT core_base_module_files_pkey PRIMARY KEY (id);


--
-- TOC entry 2602 (class 2606 OID 159478)
-- Dependencies: 186 186
-- Name: core_base_module_links_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_module_links
    ADD CONSTRAINT core_base_module_links_pkey PRIMARY KEY (id);


--
-- TOC entry 2604 (class 2606 OID 159489)
-- Dependencies: 188 188
-- Name: core_base_module_navigation_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_module_navigation
    ADD CONSTRAINT core_base_module_navigation_pkey PRIMARY KEY (id);


--
-- TOC entry 2606 (class 2606 OID 159491)
-- Dependencies: 188 188
-- Name: core_base_module_navigation_position_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_module_navigation
    ADD CONSTRAINT core_base_module_navigation_position_key UNIQUE ("position");


--
-- TOC entry 2608 (class 2606 OID 159502)
-- Dependencies: 190 190
-- Name: core_base_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_modules
    ADD CONSTRAINT core_base_modules_pkey PRIMARY KEY (id);


--
-- TOC entry 2610 (class 2606 OID 159515)
-- Dependencies: 192 192
-- Name: core_base_registry_name_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_registry
    ADD CONSTRAINT core_base_registry_name_key UNIQUE (name);


--
-- TOC entry 2612 (class 2606 OID 159513)
-- Dependencies: 192 192
-- Name: core_base_registry_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_registry
    ADD CONSTRAINT core_base_registry_pkey PRIMARY KEY (id);


--
-- TOC entry 2614 (class 2606 OID 159526)
-- Dependencies: 194 194
-- Name: core_binaries_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_binaries
    ADD CONSTRAINT core_binaries_pkey PRIMARY KEY (id);


--
-- TOC entry 2616 (class 2606 OID 159537)
-- Dependencies: 196 196
-- Name: core_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_countries
    ADD CONSTRAINT core_countries_pkey PRIMARY KEY (id);


--
-- TOC entry 2618 (class 2606 OID 159548)
-- Dependencies: 198 198
-- Name: core_currencies_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_currencies
    ADD CONSTRAINT core_currencies_pkey PRIMARY KEY (id);


--
-- TOC entry 2703 (class 2606 OID 160161)
-- Dependencies: 262 262
-- Name: core_data_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_entities
    ADD CONSTRAINT core_data_entities_pkey PRIMARY KEY (id);


--
-- TOC entry 2705 (class 2606 OID 160166)
-- Dependencies: 263 263 263
-- Name: core_data_entity_has_data_entities_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_entity_has_data_entities
    ADD CONSTRAINT core_data_entity_has_data_entities_pkey PRIMARY KEY (data_entity_pid, data_entity_cid);


--
-- TOC entry 2707 (class 2606 OID 160173)
-- Dependencies: 264 264
-- Name: core_data_entity_is_item_data_entity_id_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_entity_is_item
    ADD CONSTRAINT core_data_entity_is_item_data_entity_id_key UNIQUE (data_entity_id);


--
-- TOC entry 2709 (class 2606 OID 160171)
-- Dependencies: 264 264 264
-- Name: core_data_entity_is_item_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_entity_is_item
    ADD CONSTRAINT core_data_entity_is_item_pkey PRIMARY KEY (data_entity_id, item_id);


--
-- TOC entry 2711 (class 2606 OID 160178)
-- Dependencies: 265 265 265
-- Name: core_data_parameter_field_has_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_field_has_methods
    ADD CONSTRAINT core_data_parameter_field_has_methods_pkey PRIMARY KEY (parameter_field_id, parameter_method_id);


--
-- TOC entry 2713 (class 2606 OID 160183)
-- Dependencies: 266 266 266
-- Name: core_data_parameter_field_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_field_limits
    ADD CONSTRAINT core_data_parameter_field_limits_pkey PRIMARY KEY (parameter_limit_id, parameter_field_id);


--
-- TOC entry 2715 (class 2606 OID 160194)
-- Dependencies: 268 268
-- Name: core_data_parameter_field_values_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_field_values
    ADD CONSTRAINT core_data_parameter_field_values_pkey PRIMARY KEY (id);


--
-- TOC entry 2717 (class 2606 OID 160205)
-- Dependencies: 270 270
-- Name: core_data_parameter_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_fields
    ADD CONSTRAINT core_data_parameter_fields_pkey PRIMARY KEY (id);


--
-- TOC entry 2719 (class 2606 OID 160212)
-- Dependencies: 271 271
-- Name: core_data_parameter_has_non_template_parameter_id_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_has_non_template
    ADD CONSTRAINT core_data_parameter_has_non_template_parameter_id_key UNIQUE (parameter_id);


--
-- TOC entry 2721 (class 2606 OID 160210)
-- Dependencies: 271 271 271
-- Name: core_data_parameter_has_non_template_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_has_non_template
    ADD CONSTRAINT core_data_parameter_has_non_template_pkey PRIMARY KEY (parameter_id, non_template_id);


--
-- TOC entry 2723 (class 2606 OID 160219)
-- Dependencies: 272 272
-- Name: core_data_parameter_has_template_parameter_id_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_has_template
    ADD CONSTRAINT core_data_parameter_has_template_parameter_id_key UNIQUE (parameter_id);


--
-- TOC entry 2727 (class 2606 OID 160230)
-- Dependencies: 274 274
-- Name: core_data_parameter_limits_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_limits
    ADD CONSTRAINT core_data_parameter_limits_pkey PRIMARY KEY (id);


--
-- TOC entry 2729 (class 2606 OID 160241)
-- Dependencies: 276 276
-- Name: core_data_parameter_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_methods
    ADD CONSTRAINT core_data_parameter_methods_pkey PRIMARY KEY (id);


--
-- TOC entry 2731 (class 2606 OID 160246)
-- Dependencies: 277 277 277
-- Name: core_data_parameter_non_template_has_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_non_template_has_fields
    ADD CONSTRAINT core_data_parameter_non_template_has_fields_pkey PRIMARY KEY (non_template_id, parameter_field_id);


--
-- TOC entry 2733 (class 2606 OID 160254)
-- Dependencies: 279 279
-- Name: core_data_parameter_non_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_non_templates
    ADD CONSTRAINT core_data_parameter_non_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 2735 (class 2606 OID 160259)
-- Dependencies: 280 280 280
-- Name: core_data_parameter_template_has_fields_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_template_has_fields
    ADD CONSTRAINT core_data_parameter_template_has_fields_pkey PRIMARY KEY (template_id, parameter_field_id);


--
-- TOC entry 2737 (class 2606 OID 160272)
-- Dependencies: 282 282
-- Name: core_data_parameter_templates_internal_name_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_templates
    ADD CONSTRAINT core_data_parameter_templates_internal_name_key UNIQUE (internal_name);


--
-- TOC entry 2739 (class 2606 OID 160270)
-- Dependencies: 282 282
-- Name: core_data_parameter_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_templates
    ADD CONSTRAINT core_data_parameter_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 2741 (class 2606 OID 160283)
-- Dependencies: 284 284
-- Name: core_data_parameter_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_versions
    ADD CONSTRAINT core_data_parameter_versions_pkey PRIMARY KEY (id);


--
-- TOC entry 2743 (class 2606 OID 160291)
-- Dependencies: 286 286
-- Name: core_data_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameters
    ADD CONSTRAINT core_data_parameters_pkey PRIMARY KEY (id);


--
-- TOC entry 2745 (class 2606 OID 160296)
-- Dependencies: 287 287
-- Name: core_data_user_data_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_user_data
    ADD CONSTRAINT core_data_user_data_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2872 (class 2606 OID 161370)
-- Dependencies: 371 371
-- Name: core_equipment_cats_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_equipment_cats
    ADD CONSTRAINT core_equipment_cats_pkey PRIMARY KEY (id);


--
-- TOC entry 2874 (class 2606 OID 161375)
-- Dependencies: 372 372 372
-- Name: core_equipment_has_organisation_units_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_equipment_has_organisation_units
    ADD CONSTRAINT core_equipment_has_organisation_units_pkey PRIMARY KEY (equipment_id, organisation_unit_id);


--
-- TOC entry 2876 (class 2606 OID 161380)
-- Dependencies: 373 373 373
-- Name: core_equipment_has_responsible_persons_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_equipment_has_responsible_persons
    ADD CONSTRAINT core_equipment_has_responsible_persons_pkey PRIMARY KEY (equipment_id, user_id);


--
-- TOC entry 2878 (class 2606 OID 161387)
-- Dependencies: 374 374
-- Name: core_equipment_is_item_equipment_id_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_equipment_is_item
    ADD CONSTRAINT core_equipment_is_item_equipment_id_key UNIQUE (equipment_id);


--
-- TOC entry 2880 (class 2606 OID 161385)
-- Dependencies: 374 374 374
-- Name: core_equipment_is_item_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_equipment_is_item
    ADD CONSTRAINT core_equipment_is_item_pkey PRIMARY KEY (equipment_id, item_id);


--
-- TOC entry 2870 (class 2606 OID 161359)
-- Dependencies: 369 369
-- Name: core_equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_equipment
    ADD CONSTRAINT core_equipment_pkey PRIMARY KEY (id);


--
-- TOC entry 2882 (class 2606 OID 161398)
-- Dependencies: 376 376
-- Name: core_equipment_types_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_equipment_types
    ADD CONSTRAINT core_equipment_types_pkey PRIMARY KEY (id);


--
-- TOC entry 2620 (class 2606 OID 159561)
-- Dependencies: 200 200
-- Name: core_extensions_identifer_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_extensions
    ADD CONSTRAINT core_extensions_identifer_key UNIQUE (identifier);


--
-- TOC entry 2622 (class 2606 OID 159559)
-- Dependencies: 200 200
-- Name: core_extensions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_extensions
    ADD CONSTRAINT core_extensions_pkey PRIMARY KEY (id);


--
-- TOC entry 2748 (class 2606 OID 160304)
-- Dependencies: 289 289
-- Name: core_file_image_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_file_image_cache
    ADD CONSTRAINT core_file_image_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 2751 (class 2606 OID 160312)
-- Dependencies: 290 290
-- Name: core_file_version_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_file_version_blobs
    ADD CONSTRAINT core_file_version_blobs_pkey PRIMARY KEY (file_version_id);


--
-- TOC entry 2755 (class 2606 OID 160323)
-- Dependencies: 292 292
-- Name: core_file_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_file_versions
    ADD CONSTRAINT core_file_versions_pkey PRIMARY KEY (id);


--
-- TOC entry 2757 (class 2606 OID 160325)
-- Dependencies: 292 292 292
-- Name: core_file_versions_toid_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_file_versions
    ADD CONSTRAINT core_file_versions_toid_key UNIQUE (toid, internal_revision);


--
-- TOC entry 2759 (class 2606 OID 160333)
-- Dependencies: 294 294
-- Name: core_files_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_files
    ADD CONSTRAINT core_files_pkey PRIMARY KEY (id);


--
-- TOC entry 2761 (class 2606 OID 160344)
-- Dependencies: 296 296
-- Name: core_folder_concretion_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_folder_concretion
    ADD CONSTRAINT core_folder_concretion_pkey PRIMARY KEY (id);


--
-- TOC entry 2763 (class 2606 OID 160349)
-- Dependencies: 297 297 297
-- Name: core_folder_is_group_folder_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_folder_is_group_folder
    ADD CONSTRAINT core_folder_is_group_folder_pkey PRIMARY KEY (group_id, folder_id);


--
-- TOC entry 2765 (class 2606 OID 160354)
-- Dependencies: 298 298 298
-- Name: core_folder_is_organisation_unit_folder_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_folder_is_organisation_unit_folder
    ADD CONSTRAINT core_folder_is_organisation_unit_folder_pkey PRIMARY KEY (organisation_unit_id, folder_id);


--
-- TOC entry 2767 (class 2606 OID 160359)
-- Dependencies: 299 299
-- Name: core_folder_is_system_folder_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_folder_is_system_folder
    ADD CONSTRAINT core_folder_is_system_folder_pkey PRIMARY KEY (folder_id);


--
-- TOC entry 2769 (class 2606 OID 160364)
-- Dependencies: 300 300 300
-- Name: core_folder_is_user_folder_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_folder_is_user_folder
    ADD CONSTRAINT core_folder_is_user_folder_pkey PRIMARY KEY (user_id, folder_id);


--
-- TOC entry 2772 (class 2606 OID 160377)
-- Dependencies: 302 302
-- Name: core_folders_path_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_folders
    ADD CONSTRAINT core_folders_path_key UNIQUE (path);


--
-- TOC entry 2627 (class 2606 OID 159580)
-- Dependencies: 204 204
-- Name: core_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_groups
    ADD CONSTRAINT core_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 2677 (class 2606 OID 160000)
-- Dependencies: 238 238
-- Name: core_item_class_has_item_information_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_item_class_has_item_information
    ADD CONSTRAINT core_item_class_has_item_information_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2679 (class 2606 OID 160011)
-- Dependencies: 240 240
-- Name: core_item_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_item_classes
    ADD CONSTRAINT core_item_classes_pkey PRIMARY KEY (id);


--
-- TOC entry 2681 (class 2606 OID 160022)
-- Dependencies: 242 242
-- Name: core_item_concretion_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_item_concretion
    ADD CONSTRAINT core_item_concretion_pkey PRIMARY KEY (id);


--
-- TOC entry 2683 (class 2606 OID 160030)
-- Dependencies: 244 244
-- Name: core_item_has_item_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_item_has_item_classes
    ADD CONSTRAINT core_item_has_item_classes_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2685 (class 2606 OID 160038)
-- Dependencies: 246 246
-- Name: core_item_has_item_information_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_item_has_item_information
    ADD CONSTRAINT core_item_has_item_information_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2810 (class 2606 OID 160833)
-- Dependencies: 331 331
-- Name: core_item_has_project_log_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_log_has_items
    ADD CONSTRAINT core_item_has_project_log_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2687 (class 2606 OID 160049)
-- Dependencies: 248 248
-- Name: core_item_holders_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_item_holders
    ADD CONSTRAINT core_item_holders_pkey PRIMARY KEY (id);


--
-- TOC entry 2689 (class 2606 OID 160060)
-- Dependencies: 250 250
-- Name: core_item_information_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_item_information
    ADD CONSTRAINT core_item_information_pkey PRIMARY KEY (id);


--
-- TOC entry 2693 (class 2606 OID 160068)
-- Dependencies: 252 252
-- Name: core_items_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_items
    ADD CONSTRAINT core_items_pkey PRIMARY KEY (id);


--
-- TOC entry 2576 (class 2606 OID 159360)
-- Dependencies: 164 164
-- Name: core_job_types_internal_name_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_batch_types
    ADD CONSTRAINT core_job_types_internal_name_key UNIQUE (internal_name);


--
-- TOC entry 2578 (class 2606 OID 159358)
-- Dependencies: 164 164
-- Name: core_job_types_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_batch_types
    ADD CONSTRAINT core_job_types_pkey PRIMARY KEY (id);


--
-- TOC entry 2574 (class 2606 OID 159347)
-- Dependencies: 162 162
-- Name: core_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_batch_runs
    ADD CONSTRAINT core_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 2629 (class 2606 OID 159591)
-- Dependencies: 206 206
-- Name: core_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_languages
    ADD CONSTRAINT core_languages_pkey PRIMARY KEY (id);


--
-- TOC entry 2791 (class 2606 OID 160739)
-- Dependencies: 314 314
-- Name: core_location_types_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_location_types
    ADD CONSTRAINT core_location_types_pkey PRIMARY KEY (id);


--
-- TOC entry 2793 (class 2606 OID 160750)
-- Dependencies: 316 316
-- Name: core_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_locations
    ADD CONSTRAINT core_locations_pkey PRIMARY KEY (id);


--
-- TOC entry 2796 (class 2606 OID 160771)
-- Dependencies: 318 318
-- Name: core_manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_manufacturers
    ADD CONSTRAINT core_manufacturers_pkey PRIMARY KEY (id);


--
-- TOC entry 2591 (class 2606 OID 159426)
-- Dependencies: 176 176
-- Name: core_measuring_unit_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_measuring_unit_categories
    ADD CONSTRAINT core_measuring_unit_categories_pkey PRIMARY KEY (id);


--
-- TOC entry 2595 (class 2606 OID 159445)
-- Dependencies: 180 180
-- Name: core_measuring_units_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_base_measuring_units
    ADD CONSTRAINT core_measuring_units_pkey PRIMARY KEY (id);


--
-- TOC entry 2695 (class 2606 OID 160123)
-- Dependencies: 254 254
-- Name: core_oldl_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_oldl_templates
    ADD CONSTRAINT core_oldl_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 2697 (class 2606 OID 160131)
-- Dependencies: 256 256
-- Name: core_olvdl_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_olvdl_templates
    ADD CONSTRAINT core_olvdl_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 2662 (class 2606 OID 159894)
-- Dependencies: 229 229
-- Name: core_organ_unit_types_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_organisation_unit_types
    ADD CONSTRAINT core_organ_unit_types_pkey PRIMARY KEY (id);


--
-- TOC entry 2664 (class 2606 OID 159905)
-- Dependencies: 231 231
-- Name: core_organ_units_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_organisation_units
    ADD CONSTRAINT core_organ_units_pkey PRIMARY KEY (id);


--
-- TOC entry 2675 (class 2606 OID 159930)
-- Dependencies: 236 236 236
-- Name: core_organisation_unit_has_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_organisation_unit_has_groups
    ADD CONSTRAINT core_organisation_unit_has_groups_pkey PRIMARY KEY (organisation_unit_id, group_id);


--
-- TOC entry 2673 (class 2606 OID 159925)
-- Dependencies: 235 235 235
-- Name: core_organisation_unit_has_leaders_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_organisation_unit_has_leaders
    ADD CONSTRAINT core_organisation_unit_has_leaders_pkey PRIMARY KEY (organisation_unit_id, leader_id);


--
-- TOC entry 2671 (class 2606 OID 159920)
-- Dependencies: 234 234 234
-- Name: core_organisation_unit_has_members_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_organisation_unit_has_members
    ADD CONSTRAINT core_organisation_unit_has_members_pkey PRIMARY KEY (organisation_unit_id, member_id);


--
-- TOC entry 2669 (class 2606 OID 159915)
-- Dependencies: 233 233 233
-- Name: core_organisation_unit_has_owners_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_organisation_unit_has_owners
    ADD CONSTRAINT core_organisation_unit_has_owners_pkey PRIMARY KEY (organisation_unit_id, owner_id);


--
-- TOC entry 2667 (class 2606 OID 159910)
-- Dependencies: 232 232 232
-- Name: core_organisation_unit_has_quality_managers_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_organisation_unit_has_quality_managers
    ADD CONSTRAINT core_organisation_unit_has_quality_managers_pkey PRIMARY KEY (organisation_unit_id, quality_manager_id);


--
-- TOC entry 2631 (class 2606 OID 159602)
-- Dependencies: 208 208
-- Name: core_paper_sizes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_paper_sizes
    ADD CONSTRAINT core_paper_sizes_pkey PRIMARY KEY (id);


--
-- TOC entry 2725 (class 2606 OID 160217)
-- Dependencies: 272 272 272
-- Name: core_parameter_has_template_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_data_parameter_has_template
    ADD CONSTRAINT core_parameter_has_template_pkey PRIMARY KEY (parameter_id, template_id);


--
-- TOC entry 2798 (class 2606 OID 160785)
-- Dependencies: 320 320
-- Name: core_project_has_extension_runs_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_has_extension_runs
    ADD CONSTRAINT core_project_has_extension_runs_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2800 (class 2606 OID 160790)
-- Dependencies: 321 321 321
-- Name: core_project_has_folder_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_has_folder
    ADD CONSTRAINT core_project_has_folder_pkey PRIMARY KEY (project_id, folder_id);


--
-- TOC entry 2802 (class 2606 OID 160798)
-- Dependencies: 323 323
-- Name: core_project_has_items_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_has_items
    ADD CONSTRAINT core_project_has_items_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2804 (class 2606 OID 160806)
-- Dependencies: 325 325
-- Name: core_project_has_project_status_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_has_project_status
    ADD CONSTRAINT core_project_has_project_status_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2806 (class 2606 OID 160814)
-- Dependencies: 327 327
-- Name: core_project_links_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_links
    ADD CONSTRAINT core_project_links_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2812 (class 2606 OID 160843)
-- Dependencies: 333 333
-- Name: core_project_log_has_project_status_log_id_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_log_has_project_status
    ADD CONSTRAINT core_project_log_has_project_status_log_id_key UNIQUE (log_id);


--
-- TOC entry 2814 (class 2606 OID 160841)
-- Dependencies: 333 333
-- Name: core_project_log_has_project_status_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_log_has_project_status
    ADD CONSTRAINT core_project_log_has_project_status_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2808 (class 2606 OID 160825)
-- Dependencies: 329 329
-- Name: core_project_log_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_log
    ADD CONSTRAINT core_project_log_pkey PRIMARY KEY (id);


--
-- TOC entry 2816 (class 2606 OID 160851)
-- Dependencies: 335 335
-- Name: core_project_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_permissions
    ADD CONSTRAINT core_project_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 2821 (class 2606 OID 160867)
-- Dependencies: 338 338 338 338
-- Name: core_project_status_has_folder_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_status_has_folder
    ADD CONSTRAINT core_project_status_has_folder_pkey PRIMARY KEY (project_id, project_status_id, folder_id);


--
-- TOC entry 2819 (class 2606 OID 160862)
-- Dependencies: 337 337
-- Name: core_project_status_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_status
    ADD CONSTRAINT core_project_status_pkey PRIMARY KEY (id);


--
-- TOC entry 2823 (class 2606 OID 160872)
-- Dependencies: 339 339 339
-- Name: core_project_task_has_previous_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_task_has_previous_tasks
    ADD CONSTRAINT core_project_task_has_previous_tasks_pkey PRIMARY KEY (task_id, previous_task_id);


--
-- TOC entry 2825 (class 2606 OID 160880)
-- Dependencies: 340 340
-- Name: core_project_task_milestones_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_task_milestones
    ADD CONSTRAINT core_project_task_milestones_pkey PRIMARY KEY (task_id);


--
-- TOC entry 2827 (class 2606 OID 160888)
-- Dependencies: 341 341
-- Name: core_project_task_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_task_processes
    ADD CONSTRAINT core_project_task_processes_pkey PRIMARY KEY (task_id);


--
-- TOC entry 2829 (class 2606 OID 160893)
-- Dependencies: 342 342
-- Name: core_project_task_status_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_task_status_processes
    ADD CONSTRAINT core_project_task_status_processes_pkey PRIMARY KEY (task_id);


--
-- TOC entry 2831 (class 2606 OID 160904)
-- Dependencies: 344 344
-- Name: core_project_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_tasks
    ADD CONSTRAINT core_project_tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 2833 (class 2606 OID 160915)
-- Dependencies: 346 346
-- Name: core_project_template_cats_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_template_cats
    ADD CONSTRAINT core_project_template_cats_pkey PRIMARY KEY (id);


--
-- TOC entry 2836 (class 2606 OID 160923)
-- Dependencies: 347 347
-- Name: core_project_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_templates
    ADD CONSTRAINT core_project_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 2838 (class 2606 OID 160928)
-- Dependencies: 348 348
-- Name: core_project_user_data_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_project_user_data
    ADD CONSTRAINT core_project_user_data_pkey PRIMARY KEY (user_id);


--
-- TOC entry 2841 (class 2606 OID 160939)
-- Dependencies: 350 350
-- Name: core_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_projects
    ADD CONSTRAINT core_projects_pkey PRIMARY KEY (id);


--
-- TOC entry 2845 (class 2606 OID 161168)
-- Dependencies: 352 352 352
-- Name: core_sample_has_folder_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_has_folder
    ADD CONSTRAINT core_sample_has_folder_pkey PRIMARY KEY (sample_id, folder_id);


--
-- TOC entry 2847 (class 2606 OID 161176)
-- Dependencies: 354 354
-- Name: core_sample_has_items_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_has_items
    ADD CONSTRAINT core_sample_has_items_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2849 (class 2606 OID 161184)
-- Dependencies: 356 356
-- Name: core_sample_has_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_has_locations
    ADD CONSTRAINT core_sample_has_locations_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2851 (class 2606 OID 161192)
-- Dependencies: 358 358
-- Name: core_sample_has_organisation_units_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_has_organisation_units
    ADD CONSTRAINT core_sample_has_organisation_units_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2853 (class 2606 OID 161200)
-- Dependencies: 360 360
-- Name: core_sample_has_users_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_has_users
    ADD CONSTRAINT core_sample_has_users_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2855 (class 2606 OID 161205)
-- Dependencies: 361 361 361
-- Name: core_sample_is_item_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_is_item
    ADD CONSTRAINT core_sample_is_item_pkey PRIMARY KEY (sample_id, item_id);


--
-- TOC entry 2857 (class 2606 OID 161207)
-- Dependencies: 361 361
-- Name: core_sample_is_item_sample_id_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_is_item
    ADD CONSTRAINT core_sample_is_item_sample_id_key UNIQUE (sample_id);


--
-- TOC entry 2859 (class 2606 OID 161218)
-- Dependencies: 363 363
-- Name: core_sample_template_cats_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_template_cats
    ADD CONSTRAINT core_sample_template_cats_pkey PRIMARY KEY (id);


--
-- TOC entry 2862 (class 2606 OID 161226)
-- Dependencies: 364 364
-- Name: core_sample_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sample_templates
    ADD CONSTRAINT core_sample_templates_pkey PRIMARY KEY (id);


--
-- TOC entry 2866 (class 2606 OID 161237)
-- Dependencies: 366 366
-- Name: core_samples_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_samples
    ADD CONSTRAINT core_samples_pkey PRIMARY KEY (id);


--
-- TOC entry 2633 (class 2606 OID 159607)
-- Dependencies: 209 209 209
-- Name: core_service_has_log_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_service_has_log_entries
    ADD CONSTRAINT core_service_has_log_entries_pkey PRIMARY KEY (service_id, log_entry_id);


--
-- TOC entry 2635 (class 2606 OID 159618)
-- Dependencies: 211 211
-- Name: core_services_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_services
    ADD CONSTRAINT core_services_pkey PRIMARY KEY (id);


--
-- TOC entry 2637 (class 2606 OID 159629)
-- Dependencies: 213 213
-- Name: core_session_values_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_session_values
    ADD CONSTRAINT core_session_values_pkey PRIMARY KEY (id);


--
-- TOC entry 2639 (class 2606 OID 159631)
-- Dependencies: 213 213 213
-- Name: core_session_values_session_id_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_session_values
    ADD CONSTRAINT core_session_values_session_id_key UNIQUE (session_id, address);


--
-- TOC entry 2642 (class 2606 OID 159639)
-- Dependencies: 214 214
-- Name: core_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_sessions
    ADD CONSTRAINT core_sessions_pkey PRIMARY KEY (session_id);


--
-- TOC entry 2644 (class 2606 OID 159650)
-- Dependencies: 216 216
-- Name: core_system_log_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_system_log
    ADD CONSTRAINT core_system_log_pkey PRIMARY KEY (id);


--
-- TOC entry 2646 (class 2606 OID 159661)
-- Dependencies: 218 218
-- Name: core_system_log_types_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_system_log_types
    ADD CONSTRAINT core_system_log_types_pkey PRIMARY KEY (id);


--
-- TOC entry 2648 (class 2606 OID 159672)
-- Dependencies: 220 220
-- Name: core_system_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_system_messages
    ADD CONSTRAINT core_system_messages_pkey PRIMARY KEY (id);


--
-- TOC entry 2650 (class 2606 OID 159683)
-- Dependencies: 222 222
-- Name: core_timezones_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_timezones
    ADD CONSTRAINT core_timezones_pkey PRIMARY KEY (id);


--
-- TOC entry 2652 (class 2606 OID 159688)
-- Dependencies: 223 223
-- Name: core_user_admin_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_user_admin_settings
    ADD CONSTRAINT core_user_admin_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2624 (class 2606 OID 159569)
-- Dependencies: 202 202
-- Name: core_user_has_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_group_has_users
    ADD CONSTRAINT core_user_has_groups_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2654 (class 2606 OID 159696)
-- Dependencies: 224 224
-- Name: core_user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_user_profiles
    ADD CONSTRAINT core_user_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 2656 (class 2606 OID 159704)
-- Dependencies: 225 225
-- Name: core_user_regional_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_user_regional_settings
    ADD CONSTRAINT core_user_regional_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 2658 (class 2606 OID 159715)
-- Dependencies: 227 227
-- Name: core_users_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_users
    ADD CONSTRAINT core_users_pkey PRIMARY KEY (id);


--
-- TOC entry 2660 (class 2606 OID 159717)
-- Dependencies: 227 227
-- Name: core_users_username_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_users
    ADD CONSTRAINT core_users_username_key UNIQUE (username);


--
-- TOC entry 2777 (class 2606 OID 160388)
-- Dependencies: 304 304
-- Name: core_value_types_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_value_types
    ADD CONSTRAINT core_value_types_pkey PRIMARY KEY (id);


--
-- TOC entry 2779 (class 2606 OID 160399)
-- Dependencies: 306 306
-- Name: core_value_var_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_value_var_cases
    ADD CONSTRAINT core_value_var_cases_pkey PRIMARY KEY (id);


--
-- TOC entry 2781 (class 2606 OID 160410)
-- Dependencies: 308 308
-- Name: core_value_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_value_versions
    ADD CONSTRAINT core_value_versions_pkey PRIMARY KEY (id);


--
-- TOC entry 2783 (class 2606 OID 160412)
-- Dependencies: 308 308 308
-- Name: core_value_versions_toid_key; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_value_versions
    ADD CONSTRAINT core_value_versions_toid_key UNIQUE (toid, internal_revision);


--
-- TOC entry 2786 (class 2606 OID 160420)
-- Dependencies: 310 310
-- Name: core_values_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_values
    ADD CONSTRAINT core_values_pkey PRIMARY KEY (id);


--
-- TOC entry 2843 (class 2606 OID 160944)
-- Dependencies: 351 351
-- Name: core_virtual_folder_is_project_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_virtual_folder_is_project
    ADD CONSTRAINT core_virtual_folder_is_project_pkey PRIMARY KEY (id);


--
-- TOC entry 2868 (class 2606 OID 161242)
-- Dependencies: 367 367
-- Name: core_virtual_folder_is_sample_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_virtual_folder_is_sample
    ADD CONSTRAINT core_virtual_folder_is_sample_pkey PRIMARY KEY (id);


--
-- TOC entry 2789 (class 2606 OID 160431)
-- Dependencies: 312 312
-- Name: core_virtual_folders_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_virtual_folders
    ADD CONSTRAINT core_virtual_folders_pkey PRIMARY KEY (id);


--
-- TOC entry 2701 (class 2606 OID 160153)
-- Dependencies: 260 260
-- Name: core_xml_cache_elements_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_xml_cache_elements
    ADD CONSTRAINT core_xml_cache_elements_pkey PRIMARY KEY (primary_key);


--
-- TOC entry 2699 (class 2606 OID 160142)
-- Dependencies: 258 258
-- Name: core_xml_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_xml_cache
    ADD CONSTRAINT core_xml_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 2774 (class 2606 OID 160375)
-- Dependencies: 302 302
-- Name: folders_pkey; Type: CONSTRAINT; Schema: public; Owner: dbadmin; Tablespace: 
--

ALTER TABLE ONLY core_folders
    ADD CONSTRAINT folders_pkey PRIMARY KEY (id);


--
-- TOC entry 2863 (class 1259 OID 161244)
-- Dependencies: 366
-- Name: comment_fulltext_search; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX comment_fulltext_search ON core_samples USING gist (comment_text_search_vector);


--
-- TOC entry 2581 (class 1259 OID 159718)
-- Dependencies: 168
-- Name: core_base_include_files_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_base_include_files_name_ix ON core_base_include_files USING btree (name);


--
-- TOC entry 2598 (class 1259 OID 159719)
-- Dependencies: 184
-- Name: core_base_module_files_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_base_module_files_name_ix ON core_base_module_files USING btree (name);


--
-- TOC entry 2746 (class 1259 OID 160432)
-- Dependencies: 289 289
-- Name: core_file_image_cache_height_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_file_image_cache_height_ix ON core_file_image_cache USING btree (file_version_id, height);


--
-- TOC entry 2749 (class 1259 OID 160433)
-- Dependencies: 289 289
-- Name: core_file_image_cache_width_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_file_image_cache_width_ix ON core_file_image_cache USING btree (file_version_id, width);


--
-- TOC entry 2752 (class 1259 OID 160434)
-- Dependencies: 292
-- Name: core_file_versions_file_extension_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_file_versions_file_extension_ix ON core_file_versions USING btree (file_extension);


--
-- TOC entry 2753 (class 1259 OID 160435)
-- Dependencies: 292
-- Name: core_file_versions_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_file_versions_name_ix ON core_file_versions USING btree (name);


--
-- TOC entry 2770 (class 1259 OID 160436)
-- Dependencies: 302
-- Name: core_folders_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_folders_name_ix ON core_folders USING btree (name);


--
-- TOC entry 2625 (class 1259 OID 159720)
-- Dependencies: 204
-- Name: core_groups_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_groups_name_ix ON core_groups USING btree (name);


--
-- TOC entry 2794 (class 1259 OID 160772)
-- Dependencies: 318
-- Name: core_manufacturers_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_manufacturers_name_ix ON core_manufacturers USING btree (name);


--
-- TOC entry 2883 (class 1259 OID 161399)
-- Dependencies: 376
-- Name: core_method_types_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_method_types_name_ix ON core_equipment_types USING btree (name);


--
-- TOC entry 2665 (class 1259 OID 159931)
-- Dependencies: 231
-- Name: core_organisation_units_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_organisation_units_name_ix ON core_organisation_units USING btree (name);


--
-- TOC entry 2817 (class 1259 OID 160945)
-- Dependencies: 337
-- Name: core_project_status_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_project_status_name_ix ON core_project_status USING btree (name);


--
-- TOC entry 2834 (class 1259 OID 160946)
-- Dependencies: 347
-- Name: core_project_templates_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_project_templates_name_ix ON core_project_templates USING btree (name);


--
-- TOC entry 2839 (class 1259 OID 160947)
-- Dependencies: 350
-- Name: core_projects_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_projects_name_ix ON core_projects USING btree (name);


--
-- TOC entry 2860 (class 1259 OID 161243)
-- Dependencies: 364
-- Name: core_sample_templates_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_sample_templates_name_ix ON core_sample_templates USING btree (name);


--
-- TOC entry 2864 (class 1259 OID 161245)
-- Dependencies: 366
-- Name: core_samples_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_samples_name_ix ON core_samples USING btree (name);


--
-- TOC entry 2640 (class 1259 OID 159721)
-- Dependencies: 213
-- Name: core_sessions_address_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_sessions_address_ix ON core_session_values USING btree (address);


--
-- TOC entry 2775 (class 1259 OID 160437)
-- Dependencies: 304
-- Name: core_value_types_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_value_types_name_ix ON core_value_types USING btree (name);


--
-- TOC entry 2787 (class 1259 OID 160439)
-- Dependencies: 312
-- Name: core_virtual_folders_name_ix; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX core_virtual_folders_name_ix ON core_virtual_folders USING btree (name);


--
-- TOC entry 2690 (class 1259 OID 160069)
-- Dependencies: 250
-- Name: description_fulltext_search; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX description_fulltext_search ON core_item_information USING gist (description_text_search_vector);


--
-- TOC entry 2784 (class 1259 OID 160438)
-- Dependencies: 308
-- Name: fulltext_search; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX fulltext_search ON core_value_versions USING gist (text_search_vector);


--
-- TOC entry 2691 (class 1259 OID 160070)
-- Dependencies: 250
-- Name: keywords_fulltext_search; Type: INDEX; Schema: public; Owner: dbadmin; Tablespace: 
--

CREATE INDEX keywords_fulltext_search ON core_item_information USING gist (keywords_text_search_vector);


--
-- TOC entry 2888 (class 2606 OID 159742)
-- Dependencies: 2588 166 174
-- Name: core_base_event_listeners_include_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_event_listeners
    ADD CONSTRAINT core_base_event_listeners_include_id_fkey FOREIGN KEY (include_id) REFERENCES core_base_includes(id) DEFERRABLE;


--
-- TOC entry 2889 (class 2606 OID 159747)
-- Dependencies: 2588 168 174
-- Name: core_base_include_files_include_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_include_files
    ADD CONSTRAINT core_base_include_files_include_id_fkey FOREIGN KEY (include_id) REFERENCES core_base_includes(id) DEFERRABLE;


--
-- TOC entry 2890 (class 2606 OID 159752)
-- Dependencies: 178 2594 180
-- Name: core_base_measuring_unit_ratios_denominator_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_measuring_unit_ratios
    ADD CONSTRAINT core_base_measuring_unit_ratios_denominator_unit_id_fkey FOREIGN KEY (denominator_unit_id) REFERENCES core_base_measuring_units(id) DEFERRABLE;


--
-- TOC entry 2891 (class 2606 OID 159757)
-- Dependencies: 178 2594 180
-- Name: core_base_measuring_unit_ratios_numerator_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_measuring_unit_ratios
    ADD CONSTRAINT core_base_measuring_unit_ratios_numerator_unit_id_fkey FOREIGN KEY (numerator_unit_id) REFERENCES core_base_measuring_units(id) DEFERRABLE;


--
-- TOC entry 2892 (class 2606 OID 159762)
-- Dependencies: 2594 180 180
-- Name: core_base_measuring_units_base_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_measuring_units
    ADD CONSTRAINT core_base_measuring_units_base_id_fkey FOREIGN KEY (base_id) REFERENCES core_base_measuring_units(id) DEFERRABLE;


--
-- TOC entry 2893 (class 2606 OID 159767)
-- Dependencies: 180 2590 176
-- Name: core_base_measuring_units_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_measuring_units
    ADD CONSTRAINT core_base_measuring_units_category_id_fkey FOREIGN KEY (category_id) REFERENCES core_base_measuring_unit_categories(id) DEFERRABLE;


--
-- TOC entry 2894 (class 2606 OID 159772)
-- Dependencies: 2607 190 182
-- Name: core_base_module_dialogs_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_module_dialogs
    ADD CONSTRAINT core_base_module_dialogs_module_id_fkey FOREIGN KEY (module_id) REFERENCES core_base_modules(id) DEFERRABLE;


--
-- TOC entry 2895 (class 2606 OID 159777)
-- Dependencies: 184 190 2607
-- Name: core_base_module_files_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_module_files
    ADD CONSTRAINT core_base_module_files_module_id_fkey FOREIGN KEY (module_id) REFERENCES core_base_modules(id) DEFERRABLE;


--
-- TOC entry 2896 (class 2606 OID 159782)
-- Dependencies: 2607 190 186
-- Name: core_base_module_links_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_module_links
    ADD CONSTRAINT core_base_module_links_module_id_fkey FOREIGN KEY (module_id) REFERENCES core_base_modules(id) DEFERRABLE;


--
-- TOC entry 2897 (class 2606 OID 159787)
-- Dependencies: 188 190 2607
-- Name: core_base_module_navigation_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_module_navigation
    ADD CONSTRAINT core_base_module_navigation_module_id_fkey FOREIGN KEY (module_id) REFERENCES core_base_modules(id) DEFERRABLE;


--
-- TOC entry 2898 (class 2606 OID 159792)
-- Dependencies: 174 192 2588
-- Name: core_base_registry_include_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_registry
    ADD CONSTRAINT core_base_registry_include_id_fkey FOREIGN KEY (include_id) REFERENCES core_base_includes(id) ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE;


--
-- TOC entry 2939 (class 2606 OID 160440)
-- Dependencies: 204 262 2626
-- Name: core_data_entities_owner_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_entities
    ADD CONSTRAINT core_data_entities_owner_group_id_fkey FOREIGN KEY (owner_group_id) REFERENCES core_groups(id) DEFERRABLE;


--
-- TOC entry 2940 (class 2606 OID 160445)
-- Dependencies: 262 2657 227
-- Name: core_data_entities_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_entities
    ADD CONSTRAINT core_data_entities_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2941 (class 2606 OID 160450)
-- Dependencies: 263 2702 262
-- Name: core_data_entity_has_data_entities_data_entity_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_entity_has_data_entities
    ADD CONSTRAINT core_data_entity_has_data_entities_data_entity_cid_fkey FOREIGN KEY (data_entity_cid) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2942 (class 2606 OID 160455)
-- Dependencies: 262 2702 263
-- Name: core_data_entity_has_data_entities_data_entity_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_entity_has_data_entities
    ADD CONSTRAINT core_data_entity_has_data_entities_data_entity_pid_fkey FOREIGN KEY (data_entity_pid) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2943 (class 2606 OID 160460)
-- Dependencies: 2692 252 263
-- Name: core_data_entity_has_data_entities_link_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_entity_has_data_entities
    ADD CONSTRAINT core_data_entity_has_data_entities_link_item_id_fkey FOREIGN KEY (link_item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 2944 (class 2606 OID 160465)
-- Dependencies: 262 264 2702
-- Name: core_data_entity_is_item_data_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_entity_is_item
    ADD CONSTRAINT core_data_entity_is_item_data_entity_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2945 (class 2606 OID 160470)
-- Dependencies: 264 2692 252
-- Name: core_data_entity_is_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_entity_is_item
    ADD CONSTRAINT core_data_entity_is_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 2946 (class 2606 OID 160475)
-- Dependencies: 270 2716 265
-- Name: core_data_parameter_field_has_methods_parameter_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_field_has_methods
    ADD CONSTRAINT core_data_parameter_field_has_methods_parameter_field_id_fkey FOREIGN KEY (parameter_field_id) REFERENCES core_data_parameter_fields(id) DEFERRABLE;


--
-- TOC entry 2947 (class 2606 OID 160480)
-- Dependencies: 2728 276 265
-- Name: core_data_parameter_field_has_methods_parameter_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_field_has_methods
    ADD CONSTRAINT core_data_parameter_field_has_methods_parameter_method_id_fkey FOREIGN KEY (parameter_method_id) REFERENCES core_data_parameter_methods(id) DEFERRABLE;


--
-- TOC entry 2948 (class 2606 OID 160485)
-- Dependencies: 266 2716 270
-- Name: core_data_parameter_field_limits_parameter_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_field_limits
    ADD CONSTRAINT core_data_parameter_field_limits_parameter_field_id_fkey FOREIGN KEY (parameter_field_id) REFERENCES core_data_parameter_fields(id) DEFERRABLE;


--
-- TOC entry 2949 (class 2606 OID 160490)
-- Dependencies: 274 2726 266
-- Name: core_data_parameter_field_limits_parameter_limit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_field_limits
    ADD CONSTRAINT core_data_parameter_field_limits_parameter_limit_id_fkey FOREIGN KEY (parameter_limit_id) REFERENCES core_data_parameter_limits(id) DEFERRABLE;


--
-- TOC entry 2950 (class 2606 OID 160495)
-- Dependencies: 268 270 2716
-- Name: core_data_parameter_field_values_parameter_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_field_values
    ADD CONSTRAINT core_data_parameter_field_values_parameter_field_id_fkey FOREIGN KEY (parameter_field_id) REFERENCES core_data_parameter_fields(id) DEFERRABLE;


--
-- TOC entry 2951 (class 2606 OID 160500)
-- Dependencies: 276 2728 268
-- Name: core_data_parameter_field_values_parameter_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_field_values
    ADD CONSTRAINT core_data_parameter_field_values_parameter_method_id_fkey FOREIGN KEY (parameter_method_id) REFERENCES core_data_parameter_methods(id) DEFERRABLE;


--
-- TOC entry 2952 (class 2606 OID 160505)
-- Dependencies: 2740 268 284
-- Name: core_data_parameter_field_values_parameter_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_field_values
    ADD CONSTRAINT core_data_parameter_field_values_parameter_version_id_fkey FOREIGN KEY (parameter_version_id) REFERENCES core_data_parameter_versions(id) DEFERRABLE;


--
-- TOC entry 2953 (class 2606 OID 160510)
-- Dependencies: 180 2594 270
-- Name: core_data_parameter_fields_measuring_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_fields
    ADD CONSTRAINT core_data_parameter_fields_measuring_unit_id_fkey FOREIGN KEY (measuring_unit_id) REFERENCES core_base_measuring_units(id) DEFERRABLE;


--
-- TOC entry 2954 (class 2606 OID 160515)
-- Dependencies: 270 178 2592
-- Name: core_data_parameter_fields_measuring_unit_ratio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_fields
    ADD CONSTRAINT core_data_parameter_fields_measuring_unit_ratio_id_fkey FOREIGN KEY (measuring_unit_ratio_id) REFERENCES core_base_measuring_unit_ratios(id) DEFERRABLE;


--
-- TOC entry 2955 (class 2606 OID 160520)
-- Dependencies: 279 271 2732
-- Name: core_data_parameter_has_non_template_non_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_has_non_template
    ADD CONSTRAINT core_data_parameter_has_non_template_non_template_id_fkey FOREIGN KEY (non_template_id) REFERENCES core_data_parameter_non_templates(id) DEFERRABLE;


--
-- TOC entry 2956 (class 2606 OID 160525)
-- Dependencies: 2742 286 271
-- Name: core_data_parameter_has_non_template_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_has_non_template
    ADD CONSTRAINT core_data_parameter_has_non_template_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES core_data_parameters(id) DEFERRABLE;


--
-- TOC entry 2957 (class 2606 OID 160530)
-- Dependencies: 272 2742 286
-- Name: core_data_parameter_has_template_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_has_template
    ADD CONSTRAINT core_data_parameter_has_template_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES core_data_parameters(id) DEFERRABLE;


--
-- TOC entry 2958 (class 2606 OID 160535)
-- Dependencies: 2738 282 272
-- Name: core_data_parameter_has_template_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_has_template
    ADD CONSTRAINT core_data_parameter_has_template_template_id_fkey FOREIGN KEY (template_id) REFERENCES core_data_parameter_templates(id) DEFERRABLE;


--
-- TOC entry 2959 (class 2606 OID 160540)
-- Dependencies: 2716 277 270
-- Name: core_data_parameter_non_template_has_fi_parameter_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_non_template_has_fields
    ADD CONSTRAINT core_data_parameter_non_template_has_fi_parameter_field_id_fkey FOREIGN KEY (parameter_field_id) REFERENCES core_data_parameter_fields(id) DEFERRABLE;


--
-- TOC entry 2960 (class 2606 OID 160545)
-- Dependencies: 2732 279 277
-- Name: core_data_parameter_non_template_has_field_non_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_non_template_has_fields
    ADD CONSTRAINT core_data_parameter_non_template_has_field_non_template_id_fkey FOREIGN KEY (non_template_id) REFERENCES core_data_parameter_non_templates(id) DEFERRABLE;


--
-- TOC entry 2961 (class 2606 OID 160550)
-- Dependencies: 270 280 2716
-- Name: core_data_parameter_template_has_fields_parameter_field_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_template_has_fields
    ADD CONSTRAINT core_data_parameter_template_has_fields_parameter_field_id_fkey FOREIGN KEY (parameter_field_id) REFERENCES core_data_parameter_fields(id) DEFERRABLE;


--
-- TOC entry 2962 (class 2606 OID 160555)
-- Dependencies: 280 2738 282
-- Name: core_data_parameter_template_has_fields_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_template_has_fields
    ADD CONSTRAINT core_data_parameter_template_has_fields_template_id_fkey FOREIGN KEY (template_id) REFERENCES core_data_parameter_templates(id) DEFERRABLE;


--
-- TOC entry 2963 (class 2606 OID 160560)
-- Dependencies: 227 282 2657
-- Name: core_data_parameter_templates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_templates
    ADD CONSTRAINT core_data_parameter_templates_created_by_fkey FOREIGN KEY (created_by) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2964 (class 2606 OID 160565)
-- Dependencies: 227 284 2657
-- Name: core_data_parameter_versions_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_versions
    ADD CONSTRAINT core_data_parameter_versions_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2965 (class 2606 OID 160570)
-- Dependencies: 2742 286 284
-- Name: core_data_parameter_versions_parameter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_versions
    ADD CONSTRAINT core_data_parameter_versions_parameter_id_fkey FOREIGN KEY (parameter_id) REFERENCES core_data_parameters(id) DEFERRABLE;


--
-- TOC entry 2967 (class 2606 OID 160580)
-- Dependencies: 2726 284 274
-- Name: core_data_parameter_versions_parameter_limit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_versions
    ADD CONSTRAINT core_data_parameter_versions_parameter_limit_id_fkey FOREIGN KEY (parameter_limit_id) REFERENCES core_data_parameter_limits(id) DEFERRABLE;


--
-- TOC entry 2966 (class 2606 OID 160575)
-- Dependencies: 284 284 2740
-- Name: core_data_parameter_versions_previous_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameter_versions
    ADD CONSTRAINT core_data_parameter_versions_previous_version_id_fkey FOREIGN KEY (previous_version_id) REFERENCES core_data_parameter_versions(id) DEFERRABLE;


--
-- TOC entry 2968 (class 2606 OID 160585)
-- Dependencies: 262 286 2702
-- Name: core_data_parameters_data_entitiy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_parameters
    ADD CONSTRAINT core_data_parameters_data_entitiy_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2969 (class 2606 OID 160590)
-- Dependencies: 227 2657 287
-- Name: core_data_user_data_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_data_user_data
    ADD CONSTRAINT core_data_user_data_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3062 (class 2606 OID 161410)
-- Dependencies: 2871 371 371
-- Name: core_equipment_cats_toid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_cats
    ADD CONSTRAINT core_equipment_cats_toid_fkey FOREIGN KEY (toid) REFERENCES core_equipment_cats(id) DEFERRABLE;


--
-- TOC entry 3063 (class 2606 OID 161415)
-- Dependencies: 2881 372 376
-- Name: core_equipment_has_organisation_units_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_has_organisation_units
    ADD CONSTRAINT core_equipment_has_organisation_units_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES core_equipment_types(id) DEFERRABLE;


--
-- TOC entry 3064 (class 2606 OID 161420)
-- Dependencies: 372 2663 231
-- Name: core_equipment_has_organisation_units_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_has_organisation_units
    ADD CONSTRAINT core_equipment_has_organisation_units_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 3065 (class 2606 OID 161425)
-- Dependencies: 2881 376 373
-- Name: core_equipment_has_responsible_persons_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_has_responsible_persons
    ADD CONSTRAINT core_equipment_has_responsible_persons_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES core_equipment_types(id) DEFERRABLE;


--
-- TOC entry 3066 (class 2606 OID 161430)
-- Dependencies: 373 2657 227
-- Name: core_equipment_has_responsible_persons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_has_responsible_persons
    ADD CONSTRAINT core_equipment_has_responsible_persons_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3067 (class 2606 OID 161435)
-- Dependencies: 369 2869 374
-- Name: core_equipment_is_item_equipment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_is_item
    ADD CONSTRAINT core_equipment_is_item_equipment_id_fkey FOREIGN KEY (equipment_id) REFERENCES core_equipment(id) DEFERRABLE;


--
-- TOC entry 3068 (class 2606 OID 161440)
-- Dependencies: 252 374 2692
-- Name: core_equipment_is_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_is_item
    ADD CONSTRAINT core_equipment_is_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 3060 (class 2606 OID 161400)
-- Dependencies: 227 369 2657
-- Name: core_equipment_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment
    ADD CONSTRAINT core_equipment_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3061 (class 2606 OID 161405)
-- Dependencies: 369 376 2881
-- Name: core_equipment_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment
    ADD CONSTRAINT core_equipment_type_id_fkey FOREIGN KEY (type_id) REFERENCES core_equipment_types(id) DEFERRABLE;


--
-- TOC entry 3069 (class 2606 OID 161445)
-- Dependencies: 371 376 2871
-- Name: core_equipment_types_cat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_types
    ADD CONSTRAINT core_equipment_types_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES core_equipment_cats(id) DEFERRABLE;


--
-- TOC entry 3070 (class 2606 OID 161450)
-- Dependencies: 2792 376 316
-- Name: core_equipment_types_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_types
    ADD CONSTRAINT core_equipment_types_location_id_fkey FOREIGN KEY (location_id) REFERENCES core_locations(id) DEFERRABLE;


--
-- TOC entry 3071 (class 2606 OID 161455)
-- Dependencies: 2881 376 376
-- Name: core_equipment_types_toid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_equipment_types
    ADD CONSTRAINT core_equipment_types_toid_fkey FOREIGN KEY (toid) REFERENCES core_equipment_types(id) DEFERRABLE;


--
-- TOC entry 2970 (class 2606 OID 160595)
-- Dependencies: 292 2754 289
-- Name: core_file_image_cache_file_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_file_image_cache
    ADD CONSTRAINT core_file_image_cache_file_version_id_fkey FOREIGN KEY (file_version_id) REFERENCES core_file_versions(id) DEFERRABLE;


--
-- TOC entry 2971 (class 2606 OID 160600)
-- Dependencies: 292 290 2754
-- Name: core_file_version_blobs_file_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_file_version_blobs
    ADD CONSTRAINT core_file_version_blobs_file_version_id_fkey FOREIGN KEY (file_version_id) REFERENCES core_file_versions(id) DEFERRABLE;


--
-- TOC entry 2972 (class 2606 OID 160605)
-- Dependencies: 2657 227 292
-- Name: core_file_versions_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_file_versions
    ADD CONSTRAINT core_file_versions_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2973 (class 2606 OID 160610)
-- Dependencies: 292 2754 292
-- Name: core_file_versions_previous_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_file_versions
    ADD CONSTRAINT core_file_versions_previous_version_id_fkey FOREIGN KEY (previous_version_id) REFERENCES core_file_versions(id) DEFERRABLE;


--
-- TOC entry 2974 (class 2606 OID 160615)
-- Dependencies: 294 292 2758
-- Name: core_file_versions_toid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_file_versions
    ADD CONSTRAINT core_file_versions_toid_fkey FOREIGN KEY (toid) REFERENCES core_files(id) ON UPDATE CASCADE DEFERRABLE;


--
-- TOC entry 2975 (class 2606 OID 160620)
-- Dependencies: 262 2702 294
-- Name: core_files_data_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_files
    ADD CONSTRAINT core_files_data_entity_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2976 (class 2606 OID 160625)
-- Dependencies: 296 174 2588
-- Name: core_folder_concretion_include_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_concretion
    ADD CONSTRAINT core_folder_concretion_include_id_fkey FOREIGN KEY (include_id) REFERENCES core_base_includes(id) ON DELETE CASCADE DEFERRABLE;


--
-- TOC entry 2977 (class 2606 OID 160630)
-- Dependencies: 297 2773 302
-- Name: core_folder_is_group_folder_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_is_group_folder
    ADD CONSTRAINT core_folder_is_group_folder_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES core_folders(id) DEFERRABLE;


--
-- TOC entry 2978 (class 2606 OID 160635)
-- Dependencies: 204 297 2626
-- Name: core_folder_is_group_folder_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_is_group_folder
    ADD CONSTRAINT core_folder_is_group_folder_group_id_fkey FOREIGN KEY (group_id) REFERENCES core_groups(id) DEFERRABLE;


--
-- TOC entry 2982 (class 2606 OID 160655)
-- Dependencies: 300 302 2773
-- Name: core_folder_is_home_folder_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_is_user_folder
    ADD CONSTRAINT core_folder_is_home_folder_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES core_folders(id) DEFERRABLE;


--
-- TOC entry 2983 (class 2606 OID 160660)
-- Dependencies: 2657 300 227
-- Name: core_folder_is_home_folder_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_is_user_folder
    ADD CONSTRAINT core_folder_is_home_folder_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2979 (class 2606 OID 160640)
-- Dependencies: 231 298 2663
-- Name: core_folder_is_organisation_unit_fol_organisation_unit_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_is_organisation_unit_folder
    ADD CONSTRAINT core_folder_is_organisation_unit_fol_organisation_unit_id_fkey1 FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 2980 (class 2606 OID 160645)
-- Dependencies: 2773 302 298
-- Name: core_folder_is_organisation_unit_folder_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_is_organisation_unit_folder
    ADD CONSTRAINT core_folder_is_organisation_unit_folder_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES core_folders(id) DEFERRABLE;


--
-- TOC entry 2981 (class 2606 OID 160650)
-- Dependencies: 299 302 2773
-- Name: core_folder_is_system_folder_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folder_is_system_folder
    ADD CONSTRAINT core_folder_is_system_folder_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES core_folders(id) DEFERRABLE;


--
-- TOC entry 2984 (class 2606 OID 160665)
-- Dependencies: 262 302 2702
-- Name: core_folders_data_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_folders
    ADD CONSTRAINT core_folders_data_entity_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2899 (class 2606 OID 159797)
-- Dependencies: 2626 202 204
-- Name: core_group_has_users_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_group_has_users
    ADD CONSTRAINT core_group_has_users_group_id_fkey FOREIGN KEY (group_id) REFERENCES core_groups(id) DEFERRABLE;


--
-- TOC entry 2900 (class 2606 OID 159802)
-- Dependencies: 227 202 2657
-- Name: core_group_has_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_group_has_users
    ADD CONSTRAINT core_group_has_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2928 (class 2606 OID 160071)
-- Dependencies: 240 2678 238
-- Name: core_item_class_has_item_information_item_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_class_has_item_information
    ADD CONSTRAINT core_item_class_has_item_information_item_class_id_fkey FOREIGN KEY (item_class_id) REFERENCES core_item_classes(id) DEFERRABLE;


--
-- TOC entry 2929 (class 2606 OID 160076)
-- Dependencies: 2688 250 238
-- Name: core_item_class_has_item_information_item_information_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_class_has_item_information
    ADD CONSTRAINT core_item_class_has_item_information_item_information_id_fkey FOREIGN KEY (item_information_id) REFERENCES core_item_information(id) DEFERRABLE;


--
-- TOC entry 2930 (class 2606 OID 160081)
-- Dependencies: 242 2588 174
-- Name: core_item_concretion_include_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_concretion
    ADD CONSTRAINT core_item_concretion_include_id_fkey FOREIGN KEY (include_id) REFERENCES core_base_includes(id) ON DELETE CASCADE DEFERRABLE;


--
-- TOC entry 2931 (class 2606 OID 160086)
-- Dependencies: 2678 240 244
-- Name: core_item_has_item_classes_item_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_has_item_classes
    ADD CONSTRAINT core_item_has_item_classes_item_class_id_fkey FOREIGN KEY (item_class_id) REFERENCES core_item_classes(id) DEFERRABLE;


--
-- TOC entry 2932 (class 2606 OID 160091)
-- Dependencies: 2692 252 244
-- Name: core_item_has_item_classes_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_has_item_classes
    ADD CONSTRAINT core_item_has_item_classes_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 2933 (class 2606 OID 160096)
-- Dependencies: 252 246 2692
-- Name: core_item_has_item_information_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_has_item_information
    ADD CONSTRAINT core_item_has_item_information_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 2934 (class 2606 OID 160101)
-- Dependencies: 250 2688 246
-- Name: core_item_has_item_information_item_information_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_has_item_information
    ADD CONSTRAINT core_item_has_item_information_item_information_id_fkey FOREIGN KEY (item_information_id) REFERENCES core_item_information(id) DEFERRABLE;


--
-- TOC entry 3011 (class 2606 OID 161018)
-- Dependencies: 2807 329 331
-- Name: core_item_has_project_log_project_log_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_log_has_items
    ADD CONSTRAINT core_item_has_project_log_project_log_id_fkey FOREIGN KEY (project_log_id) REFERENCES core_project_log(id) DEFERRABLE;


--
-- TOC entry 2935 (class 2606 OID 160106)
-- Dependencies: 174 2588 248
-- Name: core_item_holders_include_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_holders
    ADD CONSTRAINT core_item_holders_include_id_fkey FOREIGN KEY (include_id) REFERENCES core_base_includes(id) ON DELETE CASCADE DEFERRABLE;


--
-- TOC entry 2936 (class 2606 OID 160111)
-- Dependencies: 206 2628 250
-- Name: core_item_information_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_item_information
    ADD CONSTRAINT core_item_information_language_id_fkey FOREIGN KEY (language_id) REFERENCES core_languages(id) DEFERRABLE;


--
-- TOC entry 2887 (class 2606 OID 159737)
-- Dependencies: 2613 194 164
-- Name: core_job_types_binary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_batch_types
    ADD CONSTRAINT core_job_types_binary_id_fkey FOREIGN KEY (binary_id) REFERENCES core_binaries(id) DEFERRABLE;


--
-- TOC entry 2884 (class 2606 OID 159722)
-- Dependencies: 2613 194 162
-- Name: core_jobs_binary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_batch_runs
    ADD CONSTRAINT core_jobs_binary_id_fkey FOREIGN KEY (binary_id) REFERENCES core_binaries(id) DEFERRABLE;


--
-- TOC entry 2885 (class 2606 OID 159727)
-- Dependencies: 164 2577 162
-- Name: core_jobs_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_batch_runs
    ADD CONSTRAINT core_jobs_type_id_fkey FOREIGN KEY (type_id) REFERENCES core_base_batch_types(id) DEFERRABLE;


--
-- TOC entry 2886 (class 2606 OID 159732)
-- Dependencies: 162 2657 227
-- Name: core_jobs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_base_batch_runs
    ADD CONSTRAINT core_jobs_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2994 (class 2606 OID 160751)
-- Dependencies: 316 316 2792
-- Name: core_locations_toid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_locations
    ADD CONSTRAINT core_locations_toid_fkey FOREIGN KEY (toid) REFERENCES core_locations(id) DEFERRABLE;


--
-- TOC entry 2995 (class 2606 OID 160756)
-- Dependencies: 314 316 2790
-- Name: core_locations_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_locations
    ADD CONSTRAINT core_locations_type_id_fkey FOREIGN KEY (type_id) REFERENCES core_location_types(id) DEFERRABLE;


--
-- TOC entry 2996 (class 2606 OID 160773)
-- Dependencies: 227 2657 318
-- Name: core_manufacturers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_manufacturers
    ADD CONSTRAINT core_manufacturers_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2937 (class 2606 OID 160715)
-- Dependencies: 262 2702 254
-- Name: core_oldl_templates_data_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_oldl_templates
    ADD CONSTRAINT core_oldl_templates_data_entity_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2938 (class 2606 OID 160720)
-- Dependencies: 256 2702 262
-- Name: core_olvdl_templates_data_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_olvdl_templates
    ADD CONSTRAINT core_olvdl_templates_data_entity_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2926 (class 2606 OID 159982)
-- Dependencies: 2626 204 236
-- Name: core_organisation_unit_has_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_groups
    ADD CONSTRAINT core_organisation_unit_has_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES core_groups(id) DEFERRABLE;


--
-- TOC entry 2927 (class 2606 OID 159987)
-- Dependencies: 2663 236 231
-- Name: core_organisation_unit_has_groups_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_groups
    ADD CONSTRAINT core_organisation_unit_has_groups_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 2924 (class 2606 OID 159972)
-- Dependencies: 2657 235 227
-- Name: core_organisation_unit_has_leaders_leader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_leaders
    ADD CONSTRAINT core_organisation_unit_has_leaders_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2925 (class 2606 OID 159977)
-- Dependencies: 235 2663 231
-- Name: core_organisation_unit_has_leaders_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_leaders
    ADD CONSTRAINT core_organisation_unit_has_leaders_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 2922 (class 2606 OID 159962)
-- Dependencies: 2657 227 234
-- Name: core_organisation_unit_has_members_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_members
    ADD CONSTRAINT core_organisation_unit_has_members_member_id_fkey FOREIGN KEY (member_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2923 (class 2606 OID 159967)
-- Dependencies: 2663 234 231
-- Name: core_organisation_unit_has_members_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_members
    ADD CONSTRAINT core_organisation_unit_has_members_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 2920 (class 2606 OID 159952)
-- Dependencies: 2663 233 231
-- Name: core_organisation_unit_has_owners_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_owners
    ADD CONSTRAINT core_organisation_unit_has_owners_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 2921 (class 2606 OID 159957)
-- Dependencies: 2657 233 227
-- Name: core_organisation_unit_has_owners_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_owners
    ADD CONSTRAINT core_organisation_unit_has_owners_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2918 (class 2606 OID 159942)
-- Dependencies: 2663 231 232
-- Name: core_organisation_unit_has_quality_ma_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_quality_managers
    ADD CONSTRAINT core_organisation_unit_has_quality_ma_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 2919 (class 2606 OID 159947)
-- Dependencies: 227 2657 232
-- Name: core_organisation_unit_has_quality_mana_quality_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_unit_has_quality_managers
    ADD CONSTRAINT core_organisation_unit_has_quality_mana_quality_manager_id_fkey FOREIGN KEY (quality_manager_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2916 (class 2606 OID 159932)
-- Dependencies: 231 231 2663
-- Name: core_organisation_units_toid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_units
    ADD CONSTRAINT core_organisation_units_toid_fkey FOREIGN KEY (toid) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 2917 (class 2606 OID 159937)
-- Dependencies: 229 231 2661
-- Name: core_organisation_units_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_organisation_units
    ADD CONSTRAINT core_organisation_units_type_id_fkey FOREIGN KEY (type_id) REFERENCES core_organisation_unit_types(id) DEFERRABLE;


--
-- TOC entry 2998 (class 2606 OID 160953)
-- Dependencies: 320 200 2621
-- Name: core_project_has_extension_runs_extension_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_extension_runs
    ADD CONSTRAINT core_project_has_extension_runs_extension_id_fkey FOREIGN KEY (extension_id) REFERENCES core_extensions(id) DEFERRABLE;


--
-- TOC entry 2997 (class 2606 OID 160948)
-- Dependencies: 350 2840 320
-- Name: core_project_has_extension_runs_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_extension_runs
    ADD CONSTRAINT core_project_has_extension_runs_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 2999 (class 2606 OID 160958)
-- Dependencies: 321 2773 302
-- Name: core_project_has_folder_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_folder
    ADD CONSTRAINT core_project_has_folder_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES core_folders(id) DEFERRABLE;


--
-- TOC entry 3000 (class 2606 OID 160963)
-- Dependencies: 350 321 2840
-- Name: core_project_has_folder_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_folder
    ADD CONSTRAINT core_project_has_folder_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3001 (class 2606 OID 160968)
-- Dependencies: 2692 323 252
-- Name: core_project_has_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_items
    ADD CONSTRAINT core_project_has_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 3004 (class 2606 OID 160983)
-- Dependencies: 252 323 2692
-- Name: core_project_has_items_parent_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_items
    ADD CONSTRAINT core_project_has_items_parent_item_id_fkey FOREIGN KEY (parent_item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 3002 (class 2606 OID 160973)
-- Dependencies: 2840 323 350
-- Name: core_project_has_items_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_items
    ADD CONSTRAINT core_project_has_items_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3003 (class 2606 OID 160978)
-- Dependencies: 2818 323 337
-- Name: core_project_has_items_project_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_items
    ADD CONSTRAINT core_project_has_items_project_status_id_fkey FOREIGN KEY (project_status_id) REFERENCES core_project_status(id) DEFERRABLE;


--
-- TOC entry 3005 (class 2606 OID 160988)
-- Dependencies: 2840 350 325
-- Name: core_project_has_project_status_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_project_status
    ADD CONSTRAINT core_project_has_project_status_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3006 (class 2606 OID 160993)
-- Dependencies: 325 2818 337
-- Name: core_project_has_project_status_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_has_project_status
    ADD CONSTRAINT core_project_has_project_status_status_id_fkey FOREIGN KEY (status_id) REFERENCES core_project_status(id) DEFERRABLE;


--
-- TOC entry 3007 (class 2606 OID 160998)
-- Dependencies: 350 327 2840
-- Name: core_project_links_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_links
    ADD CONSTRAINT core_project_links_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3008 (class 2606 OID 161003)
-- Dependencies: 2840 327 350
-- Name: core_project_links_to_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_links
    ADD CONSTRAINT core_project_links_to_project_id_fkey FOREIGN KEY (to_project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3012 (class 2606 OID 161023)
-- Dependencies: 252 331 2692
-- Name: core_project_log_has_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_log_has_items
    ADD CONSTRAINT core_project_log_has_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 3013 (class 2606 OID 161028)
-- Dependencies: 333 329 2807
-- Name: core_project_log_has_project_status_log_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_log_has_project_status
    ADD CONSTRAINT core_project_log_has_project_status_log_id_fkey FOREIGN KEY (log_id) REFERENCES core_project_log(id) DEFERRABLE;


--
-- TOC entry 3014 (class 2606 OID 161033)
-- Dependencies: 337 333 2818
-- Name: core_project_log_has_project_status_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_log_has_project_status
    ADD CONSTRAINT core_project_log_has_project_status_status_id_fkey FOREIGN KEY (status_id) REFERENCES core_project_status(id) DEFERRABLE;


--
-- TOC entry 3009 (class 2606 OID 161008)
-- Dependencies: 227 2657 329
-- Name: core_project_log_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_log
    ADD CONSTRAINT core_project_log_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3010 (class 2606 OID 161013)
-- Dependencies: 329 350 2840
-- Name: core_project_log_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_log
    ADD CONSTRAINT core_project_log_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3015 (class 2606 OID 161038)
-- Dependencies: 2626 204 335
-- Name: core_project_permissions_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_permissions
    ADD CONSTRAINT core_project_permissions_group_id_fkey FOREIGN KEY (group_id) REFERENCES core_groups(id) DEFERRABLE;


--
-- TOC entry 3016 (class 2606 OID 161043)
-- Dependencies: 335 2663 231
-- Name: core_project_permissions_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_permissions
    ADD CONSTRAINT core_project_permissions_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 3017 (class 2606 OID 161048)
-- Dependencies: 2657 335 227
-- Name: core_project_permissions_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_permissions
    ADD CONSTRAINT core_project_permissions_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3018 (class 2606 OID 161053)
-- Dependencies: 335 2657 227
-- Name: core_project_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_permissions
    ADD CONSTRAINT core_project_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3019 (class 2606 OID 161058)
-- Dependencies: 338 2773 302
-- Name: core_project_status_has_folder_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_status_has_folder
    ADD CONSTRAINT core_project_status_has_folder_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES core_folders(id) DEFERRABLE;


--
-- TOC entry 3020 (class 2606 OID 161063)
-- Dependencies: 338 2840 350
-- Name: core_project_status_has_folder_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_status_has_folder
    ADD CONSTRAINT core_project_status_has_folder_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3021 (class 2606 OID 161068)
-- Dependencies: 337 2818 338
-- Name: core_project_status_has_folder_project_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_status_has_folder
    ADD CONSTRAINT core_project_status_has_folder_project_status_id_fkey FOREIGN KEY (project_status_id) REFERENCES core_project_status(id) DEFERRABLE;


--
-- TOC entry 3022 (class 2606 OID 161073)
-- Dependencies: 344 339 2830
-- Name: core_project_task_has_previous_tasks_previous_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_task_has_previous_tasks
    ADD CONSTRAINT core_project_task_has_previous_tasks_previous_task_id_fkey FOREIGN KEY (previous_task_id) REFERENCES core_project_tasks(id) DEFERRABLE;


--
-- TOC entry 3023 (class 2606 OID 161078)
-- Dependencies: 339 344 2830
-- Name: core_project_task_has_previous_tasks_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_task_has_previous_tasks
    ADD CONSTRAINT core_project_task_has_previous_tasks_task_id_fkey FOREIGN KEY (task_id) REFERENCES core_project_tasks(id) DEFERRABLE;


--
-- TOC entry 3024 (class 2606 OID 161083)
-- Dependencies: 340 344 2830
-- Name: core_project_task_milestones_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_task_milestones
    ADD CONSTRAINT core_project_task_milestones_task_id_fkey FOREIGN KEY (task_id) REFERENCES core_project_tasks(id) DEFERRABLE;


--
-- TOC entry 3025 (class 2606 OID 161088)
-- Dependencies: 2830 341 344
-- Name: core_project_task_processes_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_task_processes
    ADD CONSTRAINT core_project_task_processes_task_id_fkey FOREIGN KEY (task_id) REFERENCES core_project_tasks(id) DEFERRABLE;


--
-- TOC entry 3026 (class 2606 OID 161093)
-- Dependencies: 2818 342 337
-- Name: core_project_task_status_processes_begin_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_task_status_processes
    ADD CONSTRAINT core_project_task_status_processes_begin_status_id_fkey FOREIGN KEY (begin_status_id) REFERENCES core_project_status(id) DEFERRABLE;


--
-- TOC entry 3027 (class 2606 OID 161098)
-- Dependencies: 2818 337 342
-- Name: core_project_task_status_processes_end_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_task_status_processes
    ADD CONSTRAINT core_project_task_status_processes_end_status_id_fkey FOREIGN KEY (end_status_id) REFERENCES core_project_status(id) DEFERRABLE;


--
-- TOC entry 3028 (class 2606 OID 161103)
-- Dependencies: 344 2830 342
-- Name: core_project_task_status_processes_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_task_status_processes
    ADD CONSTRAINT core_project_task_status_processes_task_id_fkey FOREIGN KEY (task_id) REFERENCES core_project_tasks(id) DEFERRABLE;


--
-- TOC entry 3029 (class 2606 OID 161108)
-- Dependencies: 227 344 2657
-- Name: core_project_tasks_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_tasks
    ADD CONSTRAINT core_project_tasks_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3030 (class 2606 OID 161113)
-- Dependencies: 344 350 2840
-- Name: core_project_tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_tasks
    ADD CONSTRAINT core_project_tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3031 (class 2606 OID 161118)
-- Dependencies: 2832 347 346
-- Name: core_project_templates_cat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_templates
    ADD CONSTRAINT core_project_templates_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES core_project_template_cats(id) DEFERRABLE;


--
-- TOC entry 3032 (class 2606 OID 161123)
-- Dependencies: 347 2694 254
-- Name: core_project_templates_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_templates
    ADD CONSTRAINT core_project_templates_template_id_fkey FOREIGN KEY (template_id) REFERENCES core_oldl_templates(id) DEFERRABLE;


--
-- TOC entry 3033 (class 2606 OID 161128)
-- Dependencies: 348 2657 227
-- Name: core_project_user_data_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_project_user_data
    ADD CONSTRAINT core_project_user_data_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3034 (class 2606 OID 161133)
-- Dependencies: 350 2657 227
-- Name: core_projects_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_projects
    ADD CONSTRAINT core_projects_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3035 (class 2606 OID 161138)
-- Dependencies: 347 2835 350
-- Name: core_projects_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_projects
    ADD CONSTRAINT core_projects_template_id_fkey FOREIGN KEY (template_id) REFERENCES core_project_templates(id) ON UPDATE CASCADE DEFERRABLE;


--
-- TOC entry 3036 (class 2606 OID 161143)
-- Dependencies: 2663 350 231
-- Name: core_projects_toid_organ_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_projects
    ADD CONSTRAINT core_projects_toid_organ_unit_fkey FOREIGN KEY (toid_organ_unit) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 3037 (class 2606 OID 161148)
-- Dependencies: 350 2840 350
-- Name: core_projects_toid_project_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_projects
    ADD CONSTRAINT core_projects_toid_project_fkey FOREIGN KEY (toid_project) REFERENCES core_projects(id) DEFERRABLE;


--
-- TOC entry 3039 (class 2606 OID 161246)
-- Dependencies: 302 2773 352
-- Name: core_sample_has_folder_folder_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_folder
    ADD CONSTRAINT core_sample_has_folder_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES core_folders(id) DEFERRABLE;


--
-- TOC entry 3040 (class 2606 OID 161251)
-- Dependencies: 352 2865 366
-- Name: core_sample_has_folder_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_folder
    ADD CONSTRAINT core_sample_has_folder_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES core_samples(id) DEFERRABLE;


--
-- TOC entry 3041 (class 2606 OID 161256)
-- Dependencies: 2692 354 252
-- Name: core_sample_has_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_items
    ADD CONSTRAINT core_sample_has_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 3043 (class 2606 OID 161266)
-- Dependencies: 252 2692 354
-- Name: core_sample_has_items_parent_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_items
    ADD CONSTRAINT core_sample_has_items_parent_item_id_fkey FOREIGN KEY (parent_item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 3042 (class 2606 OID 161261)
-- Dependencies: 2865 354 366
-- Name: core_sample_has_items_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_items
    ADD CONSTRAINT core_sample_has_items_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES core_samples(id) DEFERRABLE;


--
-- TOC entry 3044 (class 2606 OID 161271)
-- Dependencies: 356 2792 316
-- Name: core_sample_has_locations_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_locations
    ADD CONSTRAINT core_sample_has_locations_location_id_fkey FOREIGN KEY (location_id) REFERENCES core_locations(id) DEFERRABLE;


--
-- TOC entry 3045 (class 2606 OID 161276)
-- Dependencies: 356 2865 366
-- Name: core_sample_has_locations_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_locations
    ADD CONSTRAINT core_sample_has_locations_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES core_samples(id) DEFERRABLE;


--
-- TOC entry 3046 (class 2606 OID 161281)
-- Dependencies: 356 2657 227
-- Name: core_sample_has_locations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_locations
    ADD CONSTRAINT core_sample_has_locations_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3047 (class 2606 OID 161286)
-- Dependencies: 2663 231 358
-- Name: core_sample_has_organisation_units_organisation_unit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_organisation_units
    ADD CONSTRAINT core_sample_has_organisation_units_organisation_unit_id_fkey FOREIGN KEY (organisation_unit_id) REFERENCES core_organisation_units(id) DEFERRABLE;


--
-- TOC entry 3048 (class 2606 OID 161291)
-- Dependencies: 366 2865 358
-- Name: core_sample_has_organisation_units_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_organisation_units
    ADD CONSTRAINT core_sample_has_organisation_units_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES core_samples(id) DEFERRABLE;


--
-- TOC entry 3049 (class 2606 OID 161296)
-- Dependencies: 2865 366 360
-- Name: core_sample_has_users_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_users
    ADD CONSTRAINT core_sample_has_users_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES core_samples(id) DEFERRABLE;


--
-- TOC entry 3050 (class 2606 OID 161301)
-- Dependencies: 2657 227 360
-- Name: core_sample_has_users_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_has_users
    ADD CONSTRAINT core_sample_has_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3051 (class 2606 OID 161306)
-- Dependencies: 2692 361 252
-- Name: core_sample_is_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_is_item
    ADD CONSTRAINT core_sample_is_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES core_items(id) DEFERRABLE;


--
-- TOC entry 3052 (class 2606 OID 161311)
-- Dependencies: 2865 366 361
-- Name: core_sample_is_item_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_is_item
    ADD CONSTRAINT core_sample_is_item_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES core_samples(id) DEFERRABLE;


--
-- TOC entry 3053 (class 2606 OID 161316)
-- Dependencies: 2858 364 363
-- Name: core_sample_templates_cat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_templates
    ADD CONSTRAINT core_sample_templates_cat_id_fkey FOREIGN KEY (cat_id) REFERENCES core_sample_template_cats(id) DEFERRABLE;


--
-- TOC entry 3054 (class 2606 OID 161321)
-- Dependencies: 364 254 2694
-- Name: core_sample_templates_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sample_templates
    ADD CONSTRAINT core_sample_templates_template_id_fkey FOREIGN KEY (template_id) REFERENCES core_oldl_templates(id) DEFERRABLE;


--
-- TOC entry 3055 (class 2606 OID 161326)
-- Dependencies: 2628 366 206
-- Name: core_samples_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_samples
    ADD CONSTRAINT core_samples_language_id_fkey FOREIGN KEY (language_id) REFERENCES core_languages(id) DEFERRABLE;


--
-- TOC entry 3056 (class 2606 OID 161331)
-- Dependencies: 318 366 2795
-- Name: core_samples_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_samples
    ADD CONSTRAINT core_samples_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES core_manufacturers(id) DEFERRABLE;


--
-- TOC entry 3057 (class 2606 OID 161336)
-- Dependencies: 227 366 2657
-- Name: core_samples_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_samples
    ADD CONSTRAINT core_samples_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 3058 (class 2606 OID 161341)
-- Dependencies: 364 366 2861
-- Name: core_samples_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_samples
    ADD CONSTRAINT core_samples_template_id_fkey FOREIGN KEY (template_id) REFERENCES core_sample_templates(id) ON UPDATE CASCADE DEFERRABLE;


--
-- TOC entry 2901 (class 2606 OID 159807)
-- Dependencies: 209 2643 216
-- Name: core_service_has_log_entries_log_entry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_service_has_log_entries
    ADD CONSTRAINT core_service_has_log_entries_log_entry_id_fkey FOREIGN KEY (log_entry_id) REFERENCES core_system_log(id) DEFERRABLE;


--
-- TOC entry 2902 (class 2606 OID 159812)
-- Dependencies: 209 2634 211
-- Name: core_service_has_log_entries_service_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_service_has_log_entries
    ADD CONSTRAINT core_service_has_log_entries_service_id_fkey FOREIGN KEY (service_id) REFERENCES core_services(id) DEFERRABLE;


--
-- TOC entry 2903 (class 2606 OID 159817)
-- Dependencies: 211 194 2613
-- Name: core_services_binary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_services
    ADD CONSTRAINT core_services_binary_id_fkey FOREIGN KEY (binary_id) REFERENCES core_binaries(id) DEFERRABLE;


--
-- TOC entry 2904 (class 2606 OID 159822)
-- Dependencies: 2641 214 213
-- Name: core_session_values_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_session_values
    ADD CONSTRAINT core_session_values_session_id_fkey FOREIGN KEY (session_id) REFERENCES core_sessions(session_id) DEFERRABLE;


--
-- TOC entry 2905 (class 2606 OID 159827)
-- Dependencies: 227 214 2657
-- Name: core_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_sessions
    ADD CONSTRAINT core_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2906 (class 2606 OID 159832)
-- Dependencies: 2645 218 216
-- Name: core_system_log_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_system_log
    ADD CONSTRAINT core_system_log_type_id_fkey FOREIGN KEY (type_id) REFERENCES core_system_log_types(id) DEFERRABLE;


--
-- TOC entry 2907 (class 2606 OID 159837)
-- Dependencies: 216 227 2657
-- Name: core_system_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_system_log
    ADD CONSTRAINT core_system_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2908 (class 2606 OID 159842)
-- Dependencies: 220 227 2657
-- Name: core_system_messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_system_messages
    ADD CONSTRAINT core_system_messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2909 (class 2606 OID 159847)
-- Dependencies: 2657 227 223
-- Name: core_user_admin_settings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_user_admin_settings
    ADD CONSTRAINT core_user_admin_settings_id_fkey FOREIGN KEY (id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2910 (class 2606 OID 159852)
-- Dependencies: 227 224 2657
-- Name: core_user_profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_user_profiles
    ADD CONSTRAINT core_user_profiles_id_fkey FOREIGN KEY (id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2915 (class 2606 OID 159877)
-- Dependencies: 196 225 2615
-- Name: core_user_regional_settings_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_user_regional_settings
    ADD CONSTRAINT core_user_regional_settings_country_id_fkey FOREIGN KEY (country_id) REFERENCES core_countries(id) DEFERRABLE;


--
-- TOC entry 2911 (class 2606 OID 159857)
-- Dependencies: 225 198 2617
-- Name: core_user_regional_settings_currency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_user_regional_settings
    ADD CONSTRAINT core_user_regional_settings_currency_id_fkey FOREIGN KEY (currency_id) REFERENCES core_currencies(id) DEFERRABLE;


--
-- TOC entry 2912 (class 2606 OID 159862)
-- Dependencies: 227 225 2657
-- Name: core_user_regional_settings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_user_regional_settings
    ADD CONSTRAINT core_user_regional_settings_id_fkey FOREIGN KEY (id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2913 (class 2606 OID 159867)
-- Dependencies: 225 206 2628
-- Name: core_user_regional_settings_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_user_regional_settings
    ADD CONSTRAINT core_user_regional_settings_language_id_fkey FOREIGN KEY (language_id) REFERENCES core_languages(id) DEFERRABLE;


--
-- TOC entry 2914 (class 2606 OID 159872)
-- Dependencies: 225 222 2649
-- Name: core_user_regional_settings_timezone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_user_regional_settings
    ADD CONSTRAINT core_user_regional_settings_timezone_id_fkey FOREIGN KEY (timezone_id) REFERENCES core_timezones(id) DEFERRABLE;


--
-- TOC entry 2985 (class 2606 OID 160670)
-- Dependencies: 2696 256 304
-- Name: core_value_types_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_value_types
    ADD CONSTRAINT core_value_types_template_id_fkey FOREIGN KEY (template_id) REFERENCES core_olvdl_templates(id) DEFERRABLE;


--
-- TOC entry 2986 (class 2606 OID 160675)
-- Dependencies: 2588 306 174
-- Name: core_value_var_cases_include_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_value_var_cases
    ADD CONSTRAINT core_value_var_cases_include_id_fkey FOREIGN KEY (include_id) REFERENCES core_base_includes(id) ON DELETE CASCADE DEFERRABLE;


--
-- TOC entry 2987 (class 2606 OID 160680)
-- Dependencies: 206 308 2628
-- Name: core_value_versions_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_value_versions
    ADD CONSTRAINT core_value_versions_language_id_fkey FOREIGN KEY (language_id) REFERENCES core_languages(id) DEFERRABLE;


--
-- TOC entry 2988 (class 2606 OID 160685)
-- Dependencies: 2657 227 308
-- Name: core_value_versions_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_value_versions
    ADD CONSTRAINT core_value_versions_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES core_users(id) DEFERRABLE;


--
-- TOC entry 2989 (class 2606 OID 160690)
-- Dependencies: 308 2780 308
-- Name: core_value_versions_previous_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_value_versions
    ADD CONSTRAINT core_value_versions_previous_version_id_fkey FOREIGN KEY (previous_version_id) REFERENCES core_value_versions(id) DEFERRABLE;


--
-- TOC entry 2990 (class 2606 OID 160695)
-- Dependencies: 2785 308 310
-- Name: core_value_versions_toid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_value_versions
    ADD CONSTRAINT core_value_versions_toid_fkey FOREIGN KEY (toid) REFERENCES core_values(id) DEFERRABLE;


--
-- TOC entry 2991 (class 2606 OID 160700)
-- Dependencies: 310 2702 262
-- Name: core_values_data_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_values
    ADD CONSTRAINT core_values_data_entity_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 2992 (class 2606 OID 160705)
-- Dependencies: 2776 304 310
-- Name: core_values_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_values
    ADD CONSTRAINT core_values_type_id_fkey FOREIGN KEY (type_id) REFERENCES core_value_types(id) DEFERRABLE;


--
-- TOC entry 3038 (class 2606 OID 161153)
-- Dependencies: 312 351 2788
-- Name: core_virtual_folder_is_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_virtual_folder_is_project
    ADD CONSTRAINT core_virtual_folder_is_project_id_fkey FOREIGN KEY (id) REFERENCES core_virtual_folders(id) DEFERRABLE;


--
-- TOC entry 3059 (class 2606 OID 161346)
-- Dependencies: 312 367 2788
-- Name: core_virtual_folder_is_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_virtual_folder_is_sample
    ADD CONSTRAINT core_virtual_folder_is_sample_id_fkey FOREIGN KEY (id) REFERENCES core_virtual_folders(id) DEFERRABLE;


--
-- TOC entry 2993 (class 2606 OID 160710)
-- Dependencies: 312 2702 262
-- Name: core_virtual_folders_data_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dbadmin
--

ALTER TABLE ONLY core_virtual_folders
    ADD CONSTRAINT core_virtual_folders_data_entity_id_fkey FOREIGN KEY (data_entity_id) REFERENCES core_data_entities(id) DEFERRABLE;


--
-- TOC entry 3204 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2014-01-20 13:49:49

--
-- PostgreSQL database dump complete
--

