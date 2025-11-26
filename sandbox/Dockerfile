FROM alpine:3.19

# Install essential tools
RUN apk add --no-cache \
    bash \
    neovim \
    git \
    curl \
    tree \
    htop \
    less \
    file \
    ripgrep \
    fd \
    bat \
    fzf \
    nodejs \
    npm \
    python3 \
    go \
    make \
    gcc \
    musl-dev

# Create a non-root user
RUN adduser -D -s /bin/bash visitor

# Set up nvim config directory
RUN mkdir -p /home/visitor/.config/nvim

# Copy nvim config (you can customize this)
COPY nvim-config/init.lua /home/visitor/.config/nvim/init.lua

# Create projects directory (will be mounted read-only)
RUN mkdir -p /home/visitor/projects

# Set up a nice bash prompt
RUN echo 'PS1="\[\e[32m\]visitor\[\e[0m\]@\[\e[34m\]portfolio\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]$ "' >> /home/visitor/.bashrc && \
    echo 'alias ll="ls -la"' >> /home/visitor/.bashrc && \
    echo 'alias vim="nvim"' >> /home/visitor/.bashrc && \
    echo 'export TERM=xterm-256color' >> /home/visitor/.bashrc

# Welcome message
RUN echo 'echo ""' >> /home/visitor/.bashrc && \
    echo 'echo "  Welcome to my portfolio terminal!"' >> /home/visitor/.bashrc && \
    echo 'echo "  ─────────────────────────────────"' >> /home/visitor/.bashrc && \
    echo 'echo "  Type '\''help'\'' for available commands"' >> /home/visitor/.bashrc && \
    echo 'echo "  Explore my projects in ~/projects/"' >> /home/visitor/.bashrc && \
    echo 'echo ""' >> /home/visitor/.bashrc

# Create a custom help command
RUN echo '#!/bin/bash' > /usr/local/bin/help && \
    echo 'echo ""' >> /usr/local/bin/help && \
    echo 'echo "  Available Commands:"' >> /usr/local/bin/help && \
    echo 'echo "  ───────────────────"' >> /usr/local/bin/help && \
    echo 'echo "  about      - Learn about me"' >> /usr/local/bin/help && \
    echo 'echo "  projects   - List my projects"' >> /usr/local/bin/help && \
    echo 'echo "  skills     - View my technical skills"' >> /usr/local/bin/help && \
    echo 'echo "  contact    - Get my contact info"' >> /usr/local/bin/help && \
    echo 'echo ""' >> /usr/local/bin/help && \
    echo 'echo "  Standard tools: nvim, git, ls, cat, tree, htop, etc."' >> /usr/local/bin/help && \
    echo 'echo ""' >> /usr/local/bin/help && \
    chmod +x /usr/local/bin/help

# Create portfolio commands
RUN echo '#!/bin/bash' > /usr/local/bin/about && \
    echo 'echo ""' >> /usr/local/bin/about && \
    echo 'echo "  About Me"' >> /usr/local/bin/about && \
    echo 'echo "  ────────"' >> /usr/local/bin/about && \
    echo 'echo "  [Your name here]"' >> /usr/local/bin/about && \
    echo 'echo "  [Your title/role]"' >> /usr/local/bin/about && \
    echo 'echo ""' >> /usr/local/bin/about && \
    echo 'echo "  [Your bio here]"' >> /usr/local/bin/about && \
    echo 'echo ""' >> /usr/local/bin/about && \
    chmod +x /usr/local/bin/about

RUN echo '#!/bin/bash' > /usr/local/bin/projects && \
    echo 'echo ""' >> /usr/local/bin/projects && \
    echo 'echo "  My Projects"' >> /usr/local/bin/projects && \
    echo 'echo "  ───────────"' >> /usr/local/bin/projects && \
    echo 'ls -1 ~/projects 2>/dev/null || echo "  No projects mounted"' >> /usr/local/bin/projects && \
    echo 'echo ""' >> /usr/local/bin/projects && \
    echo 'echo "  Use '\''cd ~/projects/<name>'\'' to explore"' >> /usr/local/bin/projects && \
    echo 'echo "  Use '\''nvim .'\'' to browse with neovim"' >> /usr/local/bin/projects && \
    echo 'echo ""' >> /usr/local/bin/projects && \
    chmod +x /usr/local/bin/projects

RUN echo '#!/bin/bash' > /usr/local/bin/skills && \
    echo 'echo ""' >> /usr/local/bin/skills && \
    echo 'echo "  Technical Skills"' >> /usr/local/bin/skills && \
    echo 'echo "  ────────────────"' >> /usr/local/bin/skills && \
    echo 'echo "  Languages:  [Your languages]"' >> /usr/local/bin/skills && \
    echo 'echo "  Frontend:   [Your frontend skills]"' >> /usr/local/bin/skills && \
    echo 'echo "  Backend:    [Your backend skills]"' >> /usr/local/bin/skills && \
    echo 'echo "  Tools:      [Your tools]"' >> /usr/local/bin/skills && \
    echo 'echo ""' >> /usr/local/bin/skills && \
    chmod +x /usr/local/bin/skills

RUN echo '#!/bin/bash' > /usr/local/bin/contact && \
    echo 'echo ""' >> /usr/local/bin/contact && \
    echo 'echo "  Contact Me"' >> /usr/local/bin/contact && \
    echo 'echo "  ──────────"' >> /usr/local/bin/contact && \
    echo 'echo "  Email:    [your@email.com]"' >> /usr/local/bin/contact && \
    echo 'echo "  GitHub:   [github.com/yourusername]"' >> /usr/local/bin/contact && \
    echo 'echo "  LinkedIn: [linkedin.com/in/yourprofile]"' >> /usr/local/bin/contact && \
    echo 'echo ""' >> /usr/local/bin/contact && \
    chmod +x /usr/local/bin/contact

# Set ownership
RUN chown -R visitor:visitor /home/visitor

# Switch to non-root user
USER visitor
WORKDIR /home/visitor

# Default command
CMD ["/bin/bash"]
