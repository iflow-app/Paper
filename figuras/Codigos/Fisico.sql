CREATE TYPE enum_artifact_stage AS ENUM ('pre-traceability', 'elicitation');
CREATE TYPE enum_functional_level_type AS ENUM ('epic', 'feature', 'user story');
CREATE TYPE enum_lexical_type AS ENUM ('verb', 'object', 'state');
CREATE TYPE enum_checkpoint_result_type AS ENUM ('boolean', 'int', 'text');

CREATE TABLE USER (
    user_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    email varchar(250) NOT NULL,
    password varchar(255) NOT NULL,
    name varchar(200) NOT NULL,

    CONSTRAINT user_pk PRIMARY KEY (user_id),
);

CREATE TABLE REQUIREMENT (
    requirement_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    who text NOT NULL,
    what text NOT NULL,
    why text NOT NULL,
    artifact_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    project_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    requirement_evolves_id uuid DEFAULT,uuid_generate_v4() 

    CONSTRAINT requirement_pk PRIMARY KEY (requirement_id),
    CONSTRAINT REQUIREMENT_ARTIFACT_FK FOREIGN KEY (artifact_id)
        REFERENCES ARTIFACT(artifact_id),
    CONSTRAINT REQUIREMENT_PROJECT_FK FOREIGN KEY (project_id)
        REFERENCES PROJECT(project_id),
    CONSTRAINT REQUIREMENT_REQUIREMENT_FK FOREIGN KEY (requirement_evolves_id)
        REFERENCES REQUIREMENT(requirement_evolves_id),
    
);

CREATE TABLE ARTIFACT (
    artifact_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name varchar(50) NOT NULL,
    description text NOT NULL,
    stage enum_artifact_stage NOT NULL,
    artifact_evolves_id uuid DEFAULT,uuid_generate_v4() 
    project_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT artifact_pk PRIMARY KEY (artifact_id),
    CONSTRAINT ARTIFACT_PROJECT_FK FOREIGN KEY (project_id)
        REFERENCES PROJECT(project_id),
    CONSTRAINT ARTIFACT_ARTIFACT_FK FOREIGN KEY (artifact_evolves_id)
        REFERENCES ARTIFACT(artifact_evolves_id),
);

CREATE TABLE PROJECT (
    project_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    name varchar(50) NOT NULL,
    user_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT project_pk PRIMARY KEY (project_id),
    CONSTRAINT PROJECT_USER_FK FOREIGN KEY (user_id)
        REFERENCES USER(user_id),

);

CREATE TABLE CONTENT (
    content_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    content bytea NOT NULL,
    type text NOT NULL,
    artifact_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT content_pk PRIMARY KEY (content_id),
    CONSTRAINT CONTENT_ARTIFACT_FK FOREIGN KEY (artifact_id)
        REFERENCES ARTIFACT(artifact_id),
);

CREATE TABLE NON_FUNCTIONAL (
    nfunctional_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    identifier varchar(5) NOT NULL,
    priority smallint NOT NULL,
    requirement_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT non_functional_pk PRIMARY KEY (nfunctional_id),
    CONSTRAINT NON_FUNCTIONAL_REQUIREMENT_FK FOREIGN KEY (requirement_id)
        REFERENCES REQUIREMENT(requirement_id),
);

CREATE TABLE FUNCTIONAL (
    functional_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    level_type enum_functional_level_type NOT NULL,
    identifier varchar(5) NOT NULL,
    requirement_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT functional_pk PRIMARY KEY (functional_id),
    CONSTRAINT FUNCTIONAL_REQUIREMENT_FK FOREIGN KEY (requirement_id)
        REFERENCES REQUIREMENT(requirement_id),
);

CREATE TABLE LEXICAL (
    lexical_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    notion text NOT NULL,
    impact text NOT NULL,
    type enum_lexical_type NOT NULL,
    project_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT lexical_pk PRIMARY KEY (lexical_id),
    CONSTRAINT LEXICAL_PROJECT_FK FOREIGN KEY (project_id)
        REFERENCES PROJECT(project_id),
);

CREATE TABLE VERIFICATION (
    verification_id uuid DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name text NOT NULL,
    artifact_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT verification_pk PRIMARY KEY (verification_id),
    CONSTRAINT VERIFICATION_ARTIFACT_FK FOREIGN KEY (artifact_id)
        REFERENCES ARTIFACT(artifact_id),
);

CREATE TABLE CHECKPOINT (
    result text NOT NULL,
    result_type enum_checkpoint_result_type NOT NULL,
    criteria text NOT NULL,
    verification_id uuid DEFAULT uuid_generate_v4() NOT NULL,

    CONSTRAINT CHECKPOINT_VERIFICATION_FK FOREIGN KEY (verification_id)
        REFERENCES VERIFICATION(verification_id),
);

CREATE TABLE house_of_quality (
    nfunctional_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    functional_id uuid DEFAULT uuid_generate_v4() NOT NULL,
    weight smallint NOT NULL,

    CONSTRAINT house_of_quality_NON_FUNCTIONAL_FK FOREIGN KEY (nfunctional_id)
        REFERENCES NON_FUNCTIONAL(nfunctional_id),
    CONSTRAINT house_of_quality_FUNCTIONAL_FK FOREIGN KEY (functional_id)
        REFERENCES FUNCTIONAL(functional_id),
);