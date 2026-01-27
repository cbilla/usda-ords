#!/bin/bash
#===============================================================================
# APEX DevOps Demo - Repository Setup Script
# 
# Run this script BEFORE your demo to set up the repository structure
# 
# Usage:
#   1. Open Git Bash
#   2. Navigate to your repo: cd ~/usda-ords
#   3. Run: bash setup-demo.sh
#===============================================================================

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        APEX DevOps Demo - Repository Setup Script              ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

#-------------------------------------------------------------------------------
# Step 1: Verify we're in a git repository
#-------------------------------------------------------------------------------
echo -e "${YELLOW}[Step 1/8]${NC} Verifying Git repository..."
if [ ! -d ".git" ]; then
    echo "ERROR: Not in a Git repository. Please run this from your repo folder."
        echo "       cd ~/usda-ords"
	    exit 1
	    fi
	    echo -e "${GREEN}✓ Git repository confirmed${NC}"
	    echo ""

	    #-------------------------------------------------------------------------------
	    # Step 2: Create APEX Application Folders
	    #-------------------------------------------------------------------------------
	    echo -e "${YELLOW}[Step 2/8]${NC} Creating APEX application folders..."

	    # BATCH-A: Production Apps (5)
	    mkdir -p __app__/ttc/application
	    mkdir -p __app__/slim/application
	    mkdir -p __app__/frozen/application
	    mkdir -p __app__/app4/application
	    mkdir -p __app__/app5/application

	    # BATCH-B: Development Apps (6)
	    mkdir -p __app__/devapp1/application
	    mkdir -p __app__/devapp2/application
	    mkdir -p __app__/devapp3/application
	    mkdir -p __app__/devapp4/application
	    mkdir -p __app__/devapp5/application
	    mkdir -p __app__/devapp6/application

	    echo -e "${GREEN}✓ Created 11 application folders${NC}"
	    echo ""

	    #-------------------------------------------------------------------------------
	    # Step 3: Create Database Object Folders
	    #-------------------------------------------------------------------------------
	    echo -e "${YELLOW}[Step 3/8]${NC} Creating database object folders..."

	    mkdir -p __database__/aris_usda/table
	    mkdir -p __database__/aris_usda/package
	    mkdir -p __database__/aris_usda/procedure
	    mkdir -p __database__/aris_usda/function
	    mkdir -p __database__/aris_usda/trigger
	    mkdir -p __database__/aris_usda/view
	    mkdir -p __database__/aris_usda/data

	    echo -e "${GREEN}✓ Created database folders for aris_usda schema${NC}"
	    echo ""

	    #-------------------------------------------------------------------------------
	    # Step 4: Create Sample Database Files
	    #-------------------------------------------------------------------------------
	    echo -e "${YELLOW}[Step 4/8]${NC} Creating sample database files..."

	    # Package Spec
	    cat > __database__/aris_usda/package/pkg_utils.pks << 'EOF'
	    CREATE OR REPLACE PACKAGE pkg_utils AS
	        /*
		    * Utility Package for APEX Applications
		        * Author: Development Team
			    * Created: 2025
			        */
				    
				        -- Get the current logged-in user
					    FUNCTION get_current_user RETURN VARCHAR2;
					        
						    -- Log user activity for audit trail
						        PROCEDURE log_activity(
							        p_action  IN VARCHAR2,
								        p_details IN VARCHAR2
									    );
									        
										    -- Format date for display
										        FUNCTION format_date(
											        p_date   IN DATE,
												        p_format IN VARCHAR2 DEFAULT 'DD-MON-YYYY'
													    ) RETURN VARCHAR2;
													        
														END pkg_utils;
														/
														EOF

														# Package Body
														cat > __database__/aris_usda/package/pkg_utils.pkb << 'EOF'
														CREATE OR REPLACE PACKAGE BODY pkg_utils AS

														    FUNCTION get_current_user RETURN VARCHAR2 IS
														        BEGIN
															        RETURN NVL(V('APP_USER'), USER);
																    END get_current_user;
																        
																	    PROCEDURE log_activity(
																	            p_action  IN VARCHAR2,
																		            p_details IN VARCHAR2
																			        ) IS
																				        PRAGMA AUTONOMOUS_TRANSACTION;
																					    BEGIN
																					            INSERT INTO activity_log (
																						                log_id,
																								            action,
																									                details,
																											            created_by,
																												                created_on
																														        ) VALUES (
																															            activity_log_seq.NEXTVAL,
																																                p_action,
																																		            p_details,
																																			                get_current_user,
																																					            SYSTIMESTAMP
																																						            );
																																							            COMMIT;
																																								        END log_activity;
																																									    
																																									        FUNCTION format_date(
																																										        p_date   IN DATE,
																																											        p_format IN VARCHAR2 DEFAULT 'DD-MON-YYYY'
																																												    ) RETURN VARCHAR2 IS
																																												        BEGIN
																																													        RETURN TO_CHAR(p_date, p_format);
																																														    END format_date;
																																														        
																																															END pkg_utils;
																																															/
																																															EOF

																																															# Table DDL
																																															cat > __database__/aris_usda/table/employees.sql << 'EOF'
																																															--------------------------------------------------------
																																															-- DDL for Table EMPLOYEES
																																															--------------------------------------------------------
																																															CREATE TABLE employees (
																																															    id          NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
																																															        emp_number  VARCHAR2(20) NOT NULL,
																																																    first_name  VARCHAR2(50) NOT NULL,
																																																        last_name   VARCHAR2(50) NOT NULL,
																																																	    email       VARCHAR2(255) UNIQUE,
																																																	        department  VARCHAR2(50),
																																																		    job_title   VARCHAR2(100),
																																																		        hire_date   DATE DEFAULT SYSDATE,
																																																			    status      VARCHAR2(20) DEFAULT 'ACTIVE',
																																																			        created_by  VARCHAR2(100),
																																																				    created_on  TIMESTAMP DEFAULT SYSTIMESTAMP,
																																																				        updated_by  VARCHAR2(100),
																																																					    updated_on  TIMESTAMP
																																																					    );

																																																					    -- Indexes
																																																					    CREATE INDEX idx_emp_department ON employees(department);
																																																					    CREATE INDEX idx_emp_status ON employees(status);

																																																					    -- Comments
																																																					    COMMENT ON TABLE employees IS 'Employee master table';
																																																					    COMMENT ON COLUMN employees.status IS 'ACTIVE, INACTIVE, TERMINATED';
																																																					    EOF

																																																					    # Table Alter Script (example)
																																																					    cat > __database__/aris_usda/table/employees_20250115_01.alt << 'EOF'
																																																					    --------------------------------------------------------
																																																					    -- Alter Script: Add manager_id column
																																																					    -- Date: 2025-01-15
																																																					    -- Author: John Developer
																																																					    -- Ticket: TTC-1234
																																																					    --------------------------------------------------------
																																																					    ALTER TABLE employees ADD (
																																																					        manager_id NUMBER REFERENCES employees(id)
																																																						);

																																																						CREATE INDEX idx_emp_manager ON employees(manager_id);

																																																						COMMENT ON COLUMN employees.manager_id IS 'Reference to manager employee record';
																																																						EOF

																																																						# Procedure
																																																						cat > __database__/aris_usda/procedure/process_employee.prc << 'EOF'
																																																						CREATE OR REPLACE PROCEDURE process_employee(
																																																						    p_emp_id    IN  NUMBER,
																																																						        p_action    IN  VARCHAR2,
																																																							    p_result    OUT VARCHAR2
																																																							    ) AS
																																																							        l_emp_name VARCHAR2(100);
																																																								BEGIN
																																																								    -- Get employee name
																																																								        SELECT first_name || ' ' || last_name
																																																									    INTO l_emp_name
																																																									        FROM employees
																																																										    WHERE id = p_emp_id;
																																																										        
																																																											    -- Process based on action
																																																											        CASE p_action
																																																												        WHEN 'ACTIVATE' THEN
																																																													            UPDATE employees SET status = 'ACTIVE', updated_on = SYSTIMESTAMP
																																																														                WHERE id = p_emp_id;
																																																																        WHEN 'DEACTIVATE' THEN
																																																																	            UPDATE employees SET status = 'INACTIVE', updated_on = SYSTIMESTAMP
																																																																		                WHERE id = p_emp_id;
																																																																				        ELSE
																																																																					            p_result := 'ERROR: Unknown action ' || p_action;
																																																																						                RETURN;
																																																																								    END CASE;
																																																																								        
																																																																									    pkg_utils.log_activity(p_action, 'Employee: ' || l_emp_name);
																																																																									        p_result := 'SUCCESS';
																																																																										    
																																																																										    EXCEPTION
																																																																										        WHEN NO_DATA_FOUND THEN
																																																																											        p_result := 'ERROR: Employee not found';
																																																																												    WHEN OTHERS THEN
																																																																												            p_result := 'ERROR: ' || SQLERRM;
																																																																													    END process_employee;
																																																																													    /
																																																																													    EOF

																																																																													    # Function
																																																																													    cat > __database__/aris_usda/function/get_employee_count.fnc << 'EOF'
																																																																													    CREATE OR REPLACE FUNCTION get_employee_count(
																																																																													        p_department IN VARCHAR2 DEFAULT NULL,
																																																																														    p_status     IN VARCHAR2 DEFAULT 'ACTIVE'
																																																																														    ) RETURN NUMBER AS
																																																																														        l_count NUMBER;
																																																																															BEGIN
																																																																															    SELECT COUNT(*)
																																																																															        INTO l_count
																																																																																    FROM employees
																																																																																        WHERE status = p_status
																																																																																	      AND (p_department IS NULL OR department = p_department);
																																																																																	          
																																																																																		      RETURN l_count;
																																																																																		      END get_employee_count;
																																																																																		      /
																																																																																		      EOF

																																																																																		      # View
																																																																																		      cat > __database__/aris_usda/view/v_active_employees.vw << 'EOF'
																																																																																		      CREATE OR REPLACE VIEW v_active_employees AS
																																																																																		      SELECT 
																																																																																		          e.id,
																																																																																			      e.emp_number,
																																																																																			          e.first_name,
																																																																																				      e.last_name,
																																																																																				          e.first_name || ' ' || e.last_name AS full_name,
																																																																																					      e.email,
																																																																																					          e.department,
																																																																																						      e.job_title,
																																																																																						          e.hire_date,
																																																																																							      m.first_name || ' ' || m.last_name AS manager_name
																																																																																							      FROM employees e
																																																																																							      LEFT JOIN employees m ON e.manager_id = m.id
																																																																																							      WHERE e.status = 'ACTIVE';
																																																																																							      EOF

																																																																																							      # Trigger
																																																																																							      cat > __database__/aris_usda/trigger/trg_employees_audit.trg << 'EOF'
																																																																																							      CREATE OR REPLACE TRIGGER trg_employees_audit
																																																																																							      BEFORE INSERT OR UPDATE ON employees
																																																																																							      FOR EACH ROW
																																																																																							      BEGIN
																																																																																							          IF INSERTING THEN
																																																																																								          :NEW.created_by := NVL(V('APP_USER'), USER);
																																																																																									          :NEW.created_on := SYSTIMESTAMP;
																																																																																										      END IF;
																																																																																										          
																																																																																											      IF UPDATING THEN
																																																																																											              :NEW.updated_by := NVL(V('APP_USER'), USER);
																																																																																												              :NEW.updated_on := SYSTIMESTAMP;
																																																																																													          END IF;
																																																																																														  END trg_employees_audit;
																																																																																														  /
																																																																																														  EOF

																																																																																														  # Data Script
																																																																																														  cat > __database__/aris_usda/data/seed_departments_20250101_01.sql << 'EOF'
																																																																																														  --------------------------------------------------------
																																																																																														  -- Seed Data: Department Reference Data
																																																																																														  -- Date: 2025-01-01
																																																																																														  -- Author: DBA Team
																																																																																														  --------------------------------------------------------
																																																																																														  -- Insert sample departments
																																																																																														  INSERT INTO employees (emp_number, first_name, last_name, email, department, job_title)
																																																																																														  VALUES ('EMP001', 'Admin', 'User', 'admin@example.com', 'IT', 'System Administrator');

																																																																																														  INSERT INTO employees (emp_number, first_name, last_name, email, department, job_title)
																																																																																														  VALUES ('EMP002', 'John', 'Smith', 'john.smith@example.com', 'Finance', 'Accountant');

																																																																																														  INSERT INTO employees (emp_number, first_name, last_name, email, department, job_title)
																																																																																														  VALUES ('EMP003', 'Jane', 'Doe', 'jane.doe@example.com', 'HR', 'HR Manager');

																																																																																														  COMMIT;
																																																																																														  EOF

																																																																																														  echo -e "${GREEN}✓ Created sample database files (.pks, .pkb, .prc, .fnc, .vw, .trg, .sql, .alt)${NC}"
																																																																																														  echo ""

																																																																																														  #-------------------------------------------------------------------------------
																																																																																														  # Step 5: Create Sample APEX Page Files
																																																																																														  #-------------------------------------------------------------------------------
																																																																																														  echo -e "${YELLOW}[Step 5/8]${NC} Creating sample APEX application files..."

																																																																																														  # TTC App - Home Page
																																																																																														  cat > __app__/ttc/application/page_00001.sql << 'EOF'
																																																																																														  prompt --application/pages/page_00001
																																																																																														  begin
																																																																																														  wwv_flow_imp_page.create_page(
																																																																																														   p_id=>1
																																																																																														   ,p_name=>'Home'
																																																																																														   ,p_alias=>'HOME'
																																																																																														   ,p_step_title=>'TTC Application - Home'
																																																																																														   ,p_autocomplete_on_off=>'OFF'
																																																																																														   ,p_page_template_options=>'#DEFAULT#'
																																																																																														   ,p_protection_level=>'C'
																																																																																														   ,p_page_component_map=>'13'
																																																																																														   );
																																																																																														   wwv_flow_imp_page.create_page_plug(
																																																																																														    p_id=>wwv_flow_imp.id(12345678901)
																																																																																														    ,p_plug_name=>'Welcome'
																																																																																														    ,p_region_template_options=>'#DEFAULT#'
																																																																																														    ,p_plug_template=>wwv_flow_imp.id(12345678902)
																																																																																														    ,p_plug_display_sequence=>10
																																																																																														    ,p_plug_source=>'<h2>Welcome to TTC Application</h2><p>Select an option from the menu.</p>'
																																																																																														    ,p_plug_query_num_rows=>15
																																																																																														    ,p_attribute_01=>'N'
																																																																																														    ,p_attribute_02=>'HTML'
																																																																																														    );
																																																																																														    end;
																																																																																														    /
																																																																																														    EOF

																																																																																														    # TTC App - Manifest
																																																																																														    cat > __app__/ttc/application/manifest.json << 'EOF'
																																																																																														    {
																																																																																														        "application_id": 100,
																																																																																															    "alias": "TTC",
																																																																																															        "name": "TTC Application",
																																																																																																    "version": "1.0.0",
																																																																																																        "workspace": "ARIS_WORKSPACE",
																																																																																																	    "schema": "ARIS_USDA",
																																																																																																	        "pages": [1, 2, 3, 10, 20],
																																																																																																		    "last_export": "2025-01-27T10:00:00Z"
																																																																																																		    }
																																																																																																		    EOF

																																																																																																		    # SLIM App - Manifest
																																																																																																		    cat > __app__/slim/application/manifest.json << 'EOF'
																																																																																																		    {
																																																																																																		        "application_id": 101,
																																																																																																			    "alias": "SLIM",
																																																																																																			        "name": "SLIM Application",
																																																																																																				    "version": "1.0.0",
																																																																																																				        "workspace": "ARIS_WORKSPACE",
																																																																																																					    "schema": "ARIS_USDA"
																																																																																																					    }
																																																																																																					    EOF

																																																																																																					    # Add .gitkeep files to empty directories
																																																																																																					    for dir in __app__/frozen/application __app__/app4/application __app__/app5/application \
																																																																																																					               __app__/devapp1/application __app__/devapp2/application __app__/devapp3/application \
																																																																																																						                  __app__/devapp4/application __app__/devapp5/application __app__/devapp6/application; do
																																																																																																								      touch "$dir/.gitkeep"
																																																																																																								      done

																																																																																																								      echo -e "${GREEN}✓ Created sample APEX application files${NC}"
																																																																																																								      echo ""

																																																																																																								      #-------------------------------------------------------------------------------
																																																																																																								      # Step 6: Create/Update README
																																																																																																								      #-------------------------------------------------------------------------------
																																																																																																								      echo -e "${YELLOW}[Step 6/8]${NC} Creating README.md..."

																																																																																																								      cat > README.md << 'EOF'
																																																																																																								      # USDA ORDS - APEX DevOps Repository

																																																																																																								      Automated backup and version control for Oracle APEX applications.

																																																																																																								      ## 📁 Repository Structure

																																																																																																								      ```
																																																																																																								      usda-ords/
																																																																																																								      ├── __app__/                        # APEX Application Exports
																																																																																																								      │   ├── ttc/                        # BATCH-A (Production)
																																																																																																								      │   ├── slim/                       # BATCH-A (Production)
																																																																																																								      │   ├── frozen/                     # BATCH-A (Production)
																																																																																																								      │   ├── app4/                       # BATCH-A (Production)
																																																																																																								      │   ├── app5/                       # BATCH-A (Production)
																																																																																																								      │   ├── devapp1/                    # BATCH-B (Development)
																																																																																																								      │   ├── devapp2/                    # BATCH-B (Development)
																																																																																																								      │   ├── devapp3/                    # BATCH-B (Development)
																																																																																																								      │   ├── devapp4/                    # BATCH-B (Development)
																																																																																																								      │   ├── devapp5/                    # BATCH-B (Development)
																																																																																																								      │   └── devapp6/                    # BATCH-B (Development)
																																																																																																								      │
																																																																																																								      └── __database__/                   # Database Objects
																																																																																																								          └── aris_usda/                  # Schema name
																																																																																																									          ├── table/                  # .sql (DDL), .alt (ALTER scripts)
																																																																																																										          ├── package/                # .pks (spec), .pkb (body)
																																																																																																											          ├── procedure/              # .prc
																																																																																																												          ├── function/               # .fnc
																																																																																																													          ├── trigger/                # .trg
																																																																																																														          ├── view/                   # .vw
																																																																																																															          └── data/                   # .sql (INSERT/UPDATE scripts)
																																																																																																																  ```

																																																																																																																  ## 🌿 Branching Strategy

																																																																																																																  | Branch | Purpose | Protected |
																																																																																																																  |--------|---------|-----------|
																																																																																																																  | `main` | Production-ready code | ✅ Yes |
																																																																																																																  | `develop` | Integration branch | ✅ Yes |
																																																																																																																  | `sprint/YYYY-MM` | Sprint work | No |
																																																																																																																  | `feature/*` | Individual features | No |
																																																																																																																  | `hotfix/*` | Emergency fixes | No |

																																																																																																																  ## 🔄 Workflow

																																																																																																																  ```
																																																																																																																  feature/* → sprint/* → develop → main (via Pull Requests)
																																																																																																																  ```

																																																																																																																  ### Developer Workflow

																																																																																																																  1. Create feature branch: `git checkout -b feature/ttc-new-page`
																																																																																																																  2. Develop in APEX Builder
																																																																																																																  3. Export application: `apex export -applicationid 100 -split`
																																																																																																																  4. Commit & push: `git add . && git commit && git push`
																																																																																																																  5. Create Pull Request on GitHub
																																																																																																																  6. Code review by Dev Lead
																																																																																																																  7. Merge to sprint branch

																																																																																																																  ## 📊 Application Inventory

																																																																																																																  ### BATCH-A: Production (5 apps)
																																																																																																																  | Alias | App ID | Status |
																																																																																																																  |-------|--------|--------|
																																																																																																																  | ttc | 100 | 🟢 Production |
																																																																																																																  | slim | 101 | 🟢 Production |
																																																																																																																  | frozen | 102 | 🟢 Production |
																																																																																																																  | app4 | 103 | 🟢 Production |
																																																																																																																  | app5 | 104 | 🟢 Production |

																																																																																																																  ### BATCH-B: Development (6 apps)
																																																																																																																  | Alias | App ID | Status |
																																																																																																																  |-------|--------|--------|
																																																																																																																  | devapp1-6 | 200-205 | 🟡 Development |

																																																																																																																  ## 📝 Naming Conventions

																																																																																																																  | Object Type | Extension | Example |
																																																																																																																  |-------------|-----------|---------|
																																																																																																																  | Table DDL | `.sql` | `employees.sql` |
																																																																																																																  | Alter Script | `_YYYYMMDD_NN.alt` | `employees_20250115_01.alt` |
																																																																																																																  | Package Spec | `.pks` | `pkg_utils.pks` |
																																																																																																																  | Package Body | `.pkb` | `pkg_utils.pkb` |
																																																																																																																  | Procedure | `.prc` | `process_employee.prc` |
																																																																																																																  | Function | `.fnc` | `get_employee_count.fnc` |
																																																																																																																  | View | `.vw` | `v_active_employees.vw` |
																																																																																																																  | Trigger | `.trg` | `trg_employees_audit.trg` |
																																																																																																																  | Data Script | `_YYYYMMDD_NN.sql` | `seed_data_20250101_01.sql` |
																																																																																																																  EOF

																																																																																																																  echo -e "${GREEN}✓ Created README.md${NC}"
																																																																																																																  echo ""

																																																																																																																  #-------------------------------------------------------------------------------
																																																																																																																  # Step 7: Commit and Push to Main
																																																																																																																  #-------------------------------------------------------------------------------
																																																																																																																  echo -e "${YELLOW}[Step 7/8]${NC} Committing and pushing to main branch..."

																																																																																																																  git add .
																																																																																																																  git commit -m "Setup APEX DevOps repository structure

																																																																																																																  - Add __app__ folders for BATCH-A (5 production apps) and BATCH-B (6 dev apps)
																																																																																																																  - Add __database__ folders with proper naming conventions
																																																																																																																  - Add sample files: packages, procedures, functions, views, triggers
																																																																																																																  - Add sample APEX page export files
																																																																																																																  - Update README with complete documentation"

																																																																																																																  git push origin main

																																																																																																																  echo -e "${GREEN}✓ Pushed to main branch${NC}"
																																																																																																																  echo ""

																																																																																																																  #-------------------------------------------------------------------------------
																																																																																																																  # Step 8: Create Additional Branches
																																																																																																																  #-------------------------------------------------------------------------------
																																																																																																																  echo -e "${YELLOW}[Step 8/8]${NC} Creating branches (develop, sprint/2025-02)..."

																																																																																																																  # Create develop branch
																																																																																																																  git checkout -b develop
																																																																																																																  git push origin develop
																																																																																																																  echo -e "${GREEN}  ✓ Created 'develop' branch${NC}"

																																																																																																																  # Create sprint branch
																																																																																																																  git checkout -b sprint/2025-02
																																																																																																																  git push origin sprint/2025-02
																																																																																																																  echo -e "${GREEN}  ✓ Created 'sprint/2025-02' branch${NC}"

																																																																																																																  # Return to main
																																																																																																																  git checkout main

																																																																																																																  echo ""
																																																																																																																  echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
																																																																																																																  echo -e "${BLUE}║                    🎉 SETUP COMPLETE! 🎉                       ║${NC}"
																																																																																																																  echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
																																																																																																																  echo ""
																																																																																																																  echo -e "Your repository is ready for the demo!"
																																																																																																																  echo ""
																																																																																																																  echo -e "${GREEN}Branches created:${NC}"
																																																																																																																  echo "  • main           (production)"
																																																																																																																  echo "  • develop        (integration)"
																																																																																																																  echo "  • sprint/2025-02 (current sprint)"
																																																																																																																  echo ""
																																																																																																																  echo -e "${GREEN}Folders created:${NC}"
																																																																																																																  echo "  • __app__/       (11 applications)"
																																																																																																																  echo "  • __database__/  (aris_usda schema)"
																																																																																																																  echo ""
																																																																																																																  echo -e "${YELLOW}Next steps for demo:${NC}"
																																																																																																																  echo "  1. git checkout sprint/2025-02"
																																																																																																																  echo "  2. git checkout -b feature/ttc-employee-search"
																																																																																																																  echo "  3. Create/modify files"
																																																																																																																  echo "  4. git add . && git commit && git push"
																																																																																																																  echo "  5. Create Pull Request on GitHub"
																																																																																																																  echo ""
																																																																																																																  echo -e "View your repo: ${BLUE}https://github.com/cbilla/usda-ords${NC}"
																																																																																																																  echo ""
