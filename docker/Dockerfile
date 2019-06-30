FROM golang:alpine AS builder
LABEL maintainer "Hiroki Konishi <relastle@gmail.com>"

# Install git
RUN apk update && \
    apk add --no-cache git && \
    rm -f /tmp/* /etc/apk/cache/*

# Install fzf
RUN go get -u github.com/junegunn/fzf

# Install taggo
RUN go get -u github.com/relastle/taggo

FROM alpine:latest AS vim

COPY --from=builder /go/bin/fzf /bin/
COPY --from=builder /go/bin/taggo /bin/

# Install git, zsh, curl, vim and neovim
RUN apk update && \
    apk add --no-cache git zsh curl vim neovim && \
    rm -f /tmp/* /etc/apk/cache/*

# Install vim-plug
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim && \
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Set up fzf-coalesce
WORKDIR /opt/fzf-coalesce
COPY . .
RUN mkdir -p ~/.config/nvim && \
        ln -s /opt/fzf-coalesce/docker/.vimrc ~/ && \
        ln -s /opt/fzf-coalesce/docker/.vimrc ~/.config/nvim/init.vim
RUN vim +PlugInstall +qall && \
        vim +PlugInstall +qall
