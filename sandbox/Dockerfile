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

# Set up nvim config and plugin directories
RUN mkdir -p /home/visitor/.config/nvim \
    /home/visitor/.local/share/nvim/site/pack/plugins/start

# Pre-install neovim plugins (container has no network at runtime)
WORKDIR /home/visitor/.local/share/nvim/site/pack/plugins/start

# Colorscheme
RUN git clone --depth 1 https://github.com/catppuccin/nvim.git catppuccin

# Essential plugins
RUN git clone --depth 1 https://github.com/echasnovski/mini.nvim.git
RUN git clone --depth 1 https://github.com/stevearc/oil.nvim.git
RUN git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter.git

# Pre-install treesitter parsers
RUN nvim --headless -c "TSInstallSync lua javascript typescript python go c cpp html css json markdown bash" -c "qa" 2>/dev/null || true

# Copy nvim config
COPY nvim-config/init.lua /home/visitor/.config/nvim/init.lua

# Create projects directory (will be mounted read-only)
RUN mkdir -p /home/visitor/projects

WORKDIR /home/visitor

# Set up a nice bash prompt
RUN echo 'PS1="\[\e[32m\]visitor\[\e[0m\]@\[\e[34m\]portfolio\[\e[0m\]:\[\e[33m\]\w\[\e[0m\]$ "' >> /home/visitor/.bashrc && \
    echo 'alias ll="ls -la"' >> /home/visitor/.bashrc && \
    echo 'alias vim="nvim"' >> /home/visitor/.bashrc && \
    echo 'alias cat="bat --style=plain"' >> /home/visitor/.bashrc && \
    echo 'export TERM=xterm-256color' >> /home/visitor/.bashrc && \
    echo 'export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"' >> /home/visitor/.bashrc

# Welcome script with profile picture
COPY profile.txt /home/visitor/.config/profile.txt
COPY welcome.sh /usr/local/bin/welcome
RUN chmod +x /usr/local/bin/welcome && \
    echo 'welcome' >> /home/visitor/.bashrc && \
    echo 'welcome' >> /home/visitor/.bash_profile && \
    echo 'source ~/.bashrc' >> /home/visitor/.bash_profile

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
    echo 'echo "  Neovim Keymaps:"' >> /usr/local/bin/help && \
    echo 'echo "  ───────────────"' >> /usr/local/bin/help && \
    echo 'echo "  <Space>e   - File explorer (Oil)"' >> /usr/local/bin/help && \
    echo 'echo "  <Ctrl-p>   - Find files"' >> /usr/local/bin/help && \
    echo 'echo "  <Space>fg  - Live grep"' >> /usr/local/bin/help && \
    echo 'echo "  sa/sd/sr   - Surround add/delete/replace"' >> /usr/local/bin/help && \
    echo 'echo ""' >> /usr/local/bin/help && \
    echo 'echo "  Standard tools: nvim, git, ls, cat, tree, htop, rg, fd, bat, fzf"' >> /usr/local/bin/help && \
    echo 'echo ""' >> /usr/local/bin/help && \
    chmod +x /usr/local/bin/help

# Create portfolio commands
RUN echo '#!/bin/bash' > /usr/local/bin/about && \
    echo 'echo ""' >> /usr/local/bin/about && \
    echo 'echo "  \033[38;2;198;160;246mAbout Me\033[0m"' >> /usr/local/bin/about && \
    echo 'echo "  ════════════════════════════════════════"' >> /usr/local/bin/about && \
    echo 'echo ""' >> /usr/local/bin/about && \
    echo 'echo "  I'\''m Khasar, a Computer Science student and software"' >> /usr/local/bin/about && \
    echo 'echo "  developer who loves building things for the web."' >> /usr/local/bin/about && \
    echo 'echo ""' >> /usr/local/bin/about && \
    echo 'echo "  From full-stack apps to experimental side projects,"' >> /usr/local/bin/about && \
    echo 'echo "  I'\''m constantly exploring new technologies and pushing"' >> /usr/local/bin/about && \
    echo 'echo "  my skills forward."' >> /usr/local/bin/about && \
    echo 'echo ""' >> /usr/local/bin/about && \
    echo 'echo "  This portfolio is a space to showcase my work,"' >> /usr/local/bin/about && \
    echo 'echo "  document my growth, and share what I'\''m learning"' >> /usr/local/bin/about && \
    echo 'echo "  as I continue shaping my career in software engineering."' >> /usr/local/bin/about && \
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
    echo 'echo "  \033[38;2;198;160;246mTechnical Skills\033[0m"' >> /usr/local/bin/skills && \
    echo 'echo "  ════════════════════════════════════════"' >> /usr/local/bin/skills && \
    echo 'echo ""' >> /usr/local/bin/skills && \
    echo 'echo "  \033[38;2;138;173;244mLanguages\033[0m"' >> /usr/local/bin/skills && \
    echo 'echo "  ────────────────────────────────────────"' >> /usr/local/bin/skills && \
    echo 'echo "  TypeScript · JavaScript · Go · Python · C"' >> /usr/local/bin/skills && \
    echo 'echo ""' >> /usr/local/bin/skills && \
    echo 'echo "  \033[38;2;166;218;149mFrontend\033[0m"' >> /usr/local/bin/skills && \
    echo 'echo "  ────────────────────────────────────────"' >> /usr/local/bin/skills && \
    echo 'echo "  React · Next.js · Tailwind CSS · HTML/CSS"' >> /usr/local/bin/skills && \
    echo 'echo ""' >> /usr/local/bin/skills && \
    echo 'echo "  \033[38;2;245;169;127mBackend\033[0m"' >> /usr/local/bin/skills && \
    echo 'echo "  ────────────────────────────────────────"' >> /usr/local/bin/skills && \
    echo 'echo "  Node.js · Express · PostgreSQL · REST APIs"' >> /usr/local/bin/skills && \
    echo 'echo ""' >> /usr/local/bin/skills && \
    echo 'echo "  \033[38;2;139;213;202mDevOps & Tools\033[0m"' >> /usr/local/bin/skills && \
    echo 'echo "  ────────────────────────────────────────"' >> /usr/local/bin/skills && \
    echo 'echo "  Docker · Git · AWS · Linux · Neovim · Terraform"' >> /usr/local/bin/skills && \
    echo 'echo ""' >> /usr/local/bin/skills && \
    chmod +x /usr/local/bin/skills

RUN echo '#!/bin/bash' > /usr/local/bin/contact && \
    echo 'echo ""' >> /usr/local/bin/contact && \
    echo 'echo "  \033[38;2;198;160;246mContact Me\033[0m"' >> /usr/local/bin/contact && \
    echo 'echo "  ════════════════════════════════════════"' >> /usr/local/bin/contact && \
    echo 'echo ""' >> /usr/local/bin/contact && \
    echo 'echo "  \033[38;2;165;173;203mEmail\033[0m     \033[38;2;138;173;244mkhasar.munkherdene@gmail.com\033[0m"' >> /usr/local/bin/contact && \
    echo 'echo "  \033[38;2;165;173;203mGitHub\033[0m    \033[38;2;166;218;149mhttps://github.com/KhasarMunkh\033[0m"' >> /usr/local/bin/contact && \
    echo 'echo "  \033[38;2;165;173;203mLinkedIn\033[0m  \033[38;2;139;213;202mhttps://www.linkedin.com/in/khasarmunkh/\033[0m"' >> /usr/local/bin/contact && \
    echo 'echo ""' >> /usr/local/bin/contact && \
    chmod +x /usr/local/bin/contact

# Set ownership
RUN chown -R visitor:visitor /home/visitor

# Switch to non-root user
USER visitor
WORKDIR /home/visitor

# Default command (login shell to source .bash_profile)
CMD ["/bin/bash", "-l"]
