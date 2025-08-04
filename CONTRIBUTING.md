# Contributing to Netflix Data Engineering Project

We welcome contributions to improve this data engineering pipeline! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a new branch for your feature/fix
4. Make your changes
5. Test your changes
6. Submit a pull request

## Development Setup

### Prerequisites
- Azure subscription
- Azure CLI installed
- Python 3.8+
- Databricks CLI (optional)

### Local Setup
1. Clone the repository
2. Copy `config/config.env.template` to `config/.env`
3. Update configuration with your Azure resource details
4. Follow the setup guide in `docs/setup/SETUP.md`

## Code Standards

### Python Code
- Follow PEP 8 style guidelines
- Use type hints where appropriate
- Include docstrings for functions and classes
- Write unit tests for new functionality

### Notebooks
- Keep cells focused and well-documented
- Include markdown explanations
- Clear output before committing
- Use consistent naming conventions

### SQL
- Use uppercase for SQL keywords
- Proper indentation and formatting
- Comment complex queries

## Pull Request Process

1. **Description**: Provide a clear description of what your PR does
2. **Testing**: Include evidence that your changes work
3. **Documentation**: Update relevant documentation
4. **Breaking Changes**: Clearly mark any breaking changes

### PR Template
```
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Documentation
- [ ] Code comments updated
- [ ] README updated if needed
- [ ] Setup guide updated if needed
```

## Reporting Issues

### Bug Reports
Include:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Azure regions, Databricks runtime, etc.)
- Error messages and logs

### Feature Requests
Include:
- Clear description of the proposed feature
- Use case and business justification
- Proposed implementation approach

## Code Review Guidelines

### For Contributors
- Keep PRs focused and reasonably sized
- Respond to feedback promptly
- Update your branch if conflicts arise

### For Reviewers
- Be constructive and specific in feedback
- Consider performance and security implications
- Check for proper error handling
- Verify documentation is updated

## Release Process

1. All changes go through PR review
2. Main branch should always be deployable
3. Version tags follow semantic versioning
4. Release notes document major changes

## Questions?

If you have questions about contributing:
1. Check existing issues and discussions
2. Create a new issue with the "question" label
3. Contact the maintainers

Thank you for contributing to the Netflix Data Engineering Project!
