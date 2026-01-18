#!/usr/bin/env python3
"""
Database Setup Script for CS3550 Assignment 1
Cross-platform script to set up Docker container and initialize database

This script:
1. Checks for Docker installation
2. Starts the MySQL Docker container
3. Waits for MySQL to be ready
4. Runs the schema design script
5. Runs the sample data script

Works on both Windows and macOS/Linux.

Usage:
    python setup_database.py
"""

import subprocess
import sys
import time
import platform
import os
from pathlib import Path


class Colors:
    """ANSI color codes for terminal output"""
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

    @staticmethod
    def disable():
        """Disable colors on Windows if not supported"""
        Colors.HEADER = ''
        Colors.OKBLUE = ''
        Colors.OKCYAN = ''
        Colors.OKGREEN = ''
        Colors.WARNING = ''
        Colors.FAIL = ''
        Colors.ENDC = ''
        Colors.BOLD = ''
        Colors.UNDERLINE = ''


# Disable colors on Windows unless running in a modern terminal
if platform.system() == 'Windows' and not os.environ.get('WT_SESSION'):
    Colors.disable()


def print_header(message):
    """Print a formatted header message"""
    print(f"\n{Colors.HEADER}{Colors.BOLD}{'=' * 70}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{message}{Colors.ENDC}")
    print(f"{Colors.HEADER}{Colors.BOLD}{'=' * 70}{Colors.ENDC}\n")


def print_success(message):
    """Print a success message"""
    print(f"{Colors.OKGREEN}✓ {message}{Colors.ENDC}")


def print_error(message):
    """Print an error message"""
    print(f"{Colors.FAIL}✗ {message}{Colors.ENDC}")


def print_info(message):
    """Print an info message"""
    print(f"{Colors.OKCYAN}ℹ {message}{Colors.ENDC}")


def print_warning(message):
    """Print a warning message"""
    print(f"{Colors.WARNING}⚠ {message}{Colors.ENDC}")


def run_command(command, capture_output=False, check=True):
    """
    Run a shell command

    Args:
        command: Command to run (string or list)
        capture_output: Whether to capture output
        check: Whether to raise exception on failure

    Returns:
        CompletedProcess object if capture_output=True, else None
    """
    try:
        if isinstance(command, str):
            # Use shell=True for string commands
            result = subprocess.run(
                command,
                shell=True,
                capture_output=capture_output,
                text=True,
                check=check
            )
        else:
            # Use shell=False for list commands
            result = subprocess.run(
                command,
                capture_output=capture_output,
                text=True,
                check=check
            )

        if capture_output:
            return result
        return None
    except subprocess.CalledProcessError as e:
        if check:
            raise
        return e


def check_docker_installed():
    """Check if Docker is installed and running"""
    print_info("Checking for Docker installation...")

    try:
        result = run_command(['docker', '--version'], capture_output=True)
        print_success(f"Docker is installed: {result.stdout.strip()}")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        print_error("Docker is not installed or not in PATH")
        print_info(
            "Please install Docker Desktop from: https://www.docker.com/products/docker-desktop")
        return False


def check_docker_running():
    """Check if Docker daemon is running"""
    print_info("Checking if Docker is running...")

    try:
        run_command(['docker', 'ps'], capture_output=True)
        print_success("Docker is running")
        return True
    except subprocess.CalledProcessError:
        print_error("Docker is installed but not running")
        print_info("Please start Docker Desktop and try again")
        return False


def start_docker_container():
    """Start the MySQL Docker container using docker-compose"""
    print_info("Starting MySQL Docker container...")

    try:
        # Check if container is already running
        result = run_command(
            ['docker-compose', 'ps', '-q', 'mysql'],
            capture_output=True,
            check=False
        )

        if result.stdout.strip():
            print_warning("MySQL container is already running")
            response = input(
                "Do you want to restart it? (y/N): ").strip().lower()
            if response == 'y':
                print_info("Stopping existing container...")
                run_command(['docker-compose', 'down'])
            else:
                print_info("Using existing container")
                return True

        # Start the container
        print_info("Starting container with docker-compose...")
        run_command(['docker-compose', 'up', '-d', 'mysql'])
        print_success("MySQL container started successfully")
        return True

    except subprocess.CalledProcessError as e:
        print_error(f"Failed to start Docker container: {e}")
        return False


def wait_for_mysql(max_attempts=30):
    """
    Wait for MySQL to be ready to accept connections

    Args:
        max_attempts: Maximum number of connection attempts

    Returns:
        True if MySQL is ready, False otherwise
    """
    print_info("Waiting for MySQL to be ready...")

    for attempt in range(1, max_attempts + 1):
        try:
            # Try to connect to MySQL
            result = run_command(
                [
                    'docker-compose', 'exec', '-T', 'mysql',
                    'mysql', '-uroot', '-ppassword', '-e', 'SELECT 1'
                ],
                capture_output=True,
                check=False
            )

            if result.returncode == 0:
                print_success("MySQL is ready!")
                return True

        except Exception:
            pass

        # Wait before next attempt
        print(f"  Attempt {attempt}/{max_attempts}... waiting", end='\r')
        time.sleep(2)

    print_error("\nMySQL did not become ready in time")
    return False


def run_sql_file(file_path, description):
    """
    Run a SQL file in the MySQL container

    Args:
        file_path: Path to the SQL file
        description: Description of what the file does

    Returns:
        True if successful, False otherwise
    """
    print_info(f"Running {description}...")

    # Verify file exists
    if not Path(file_path).exists():
        print_error(f"File not found: {file_path}")
        return False

    try:
        # Read the SQL file content
        with open(file_path, 'r', encoding='utf-8') as f:
            sql_content = f.read()

        # Run the SQL file in the container
        # Use docker-compose exec with stdin
        if platform.system() == 'Windows':
            # Windows command
            command = f'docker-compose exec -T mysql mysql -uroot -ppassword < "{file_path}"'
        else:
            # macOS/Linux command
            command = ['docker-compose', 'exec', '-T',
                       'mysql', 'mysql', '-uroot', '-ppassword']

        if isinstance(command, list):
            # For macOS/Linux, pipe the SQL content
            process = subprocess.Popen(
                command,
                stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )
            stdout, stderr = process.communicate(input=sql_content)

            if process.returncode != 0:
                print_error(f"Failed to run {description}")
                if stderr:
                    print(f"Error: {stderr}")
                return False
        else:
            # For Windows, use shell redirection
            result = run_command(command, capture_output=True, check=False)

            if result.returncode != 0:
                print_error(f"Failed to run {description}")
                if result.stderr:
                    print(f"Error: {result.stderr}")
                return False

        print_success(f"{description} completed successfully")
        return True

    except Exception as e:
        print_error(f"Error running {description}: {e}")
        return False


def verify_setup():
    """Verify that the database and tables were created"""
    print_info("Verifying database setup...")

    try:
        # Check tables
        result = run_command(
            [
                'docker-compose', 'exec', '-T', 'mysql',
                'mysql', '-uroot', '-ppassword', '-e',
                'USE community_college_db; SHOW TABLES;'
            ],
            capture_output=True
        )

        if 'students' in result.stdout and 'courses' in result.stdout:
            print_success("Database tables created successfully")

            # Count records
            result = run_command(
                [
                    'docker-compose', 'exec', '-T', 'mysql',
                    'mysql', '-uroot', '-ppassword', '-e',
                    'USE community_college_db; SELECT COUNT(*) FROM students;'
                ],
                capture_output=True
            )

            print_success("Sample data loaded successfully")
            print_info(f"Database setup verification complete!")
            return True
        else:
            print_warning("Some tables may be missing")
            return False

    except Exception as e:
        print_error(f"Verification failed: {e}")
        return False


def main():
    """Main execution function"""
    print_header("CS3550 Assignment 1 - Database Setup")
    print(f"Platform: {platform.system()} {platform.release()}")
    print(f"Python: {sys.version.split()[0]}\n")

    # Get the script directory
    script_dir = Path(__file__).parent.resolve()
    schema_file = script_dir / 'src' / '02_schema_design.sql'
    data_file = script_dir / 'src' / '03_sample_data.sql'

    # Step 1: Check Docker
    print_header("Step 1: Checking Docker")
    if not check_docker_installed():
        sys.exit(1)

    if not check_docker_running():
        sys.exit(1)

    # Step 2: Start Docker container
    print_header("Step 2: Starting MySQL Container")
    if not start_docker_container():
        sys.exit(1)

    # Step 3: Wait for MySQL
    print_header("Step 3: Waiting for MySQL")
    if not wait_for_mysql():
        print_error(
            "MySQL failed to start. Check Docker logs with: docker-compose logs mysql")
        sys.exit(1)

    # Step 4: Run schema script
    print_header("Step 4: Creating Database Schema")
    if not run_sql_file(schema_file, "schema design script"):
        sys.exit(1)

    # Step 5: Run sample data script
    print_header("Step 5: Loading Sample Data")
    if not run_sql_file(data_file, "sample data script"):
        sys.exit(1)

    # Step 6: Verify setup
    print_header("Step 6: Verifying Setup")
    if not verify_setup():
        print_warning(
            "Setup may be incomplete. Please check the database manually.")

    # Success!
    print_header("✓ Setup Complete!")
    print_success("Database is ready for use!")
    print_info("\nYou can now:")
    print("  1. Connect to the database using MySQL Workbench or VS Code")
    print("  2. Start working on your SQL queries")
    print("  3. Run tests with: docker-compose run --rm test-runner npm test")
    print(f"\n{Colors.BOLD}Connection Details:{Colors.ENDC}")
    print("  Host: localhost")
    print("  Port: 3306")
    print("  Username: root")
    print("  Password: password")
    print("  Database: community_college_db")
    print()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print_warning("\n\nSetup interrupted by user")
        sys.exit(130)
    except Exception as e:
        print_error(f"\n\nUnexpected error: {e}")
        sys.exit(1)
