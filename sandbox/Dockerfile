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

# Pre-install treesitter parsers for common languages
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
    echo 'echo "  Email:    khasar.munkherdene@gmail.com"' >> /usr/local/bin/contact && \
    echo 'echo "  GitHub:   https://github.com/KhasarMunkh"' >> /usr/local/bin/contact && \
    echo 'echo "  LinkedIn: https://www.linkedin.com/in/khasarmunkh/"' >> /usr/local/bin/contact && \
    echo 'echo ""' >> /usr/local/bin/contact && \
    chmod +x /usr/local/bin/contact

# Set ownership
RUN chown -R visitor:visitor /home/visitor

# Switch to non-root user
USER visitor
WORKDIR /home/visitor

# Default command (login shell to source .bash_profile)
CMD ["/bin/bash", "-l"]
