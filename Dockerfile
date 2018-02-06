# Provision download container
FROM alpine:latest as tmp
RUN apk add --no-cache git curl

# Downloading plugins
RUN curl -LSso /pathogen.vim https://tpo.pe/pathogen.vim
RUN git clone https://github.com/vim-airline/vim-airline
RUN git clone https://github.com/vim-airline/vim-airline-themes

# Building the container
FROM alpine:latest
RUN apk add --no-cache vim

# Setting up the plugin loader
RUN mkdir -p /home/user/.vim/autoload /home/user/.vim/bundle
COPY --from=tmp /pathogen.vim /home/user/.vim/autoload/pathogen.vim

# TODO: Copy my .vimrc

# Airline
COPY --from=tmp /vim-airline           /home/user/.vim/bundle/vim-airline
COPY --from=tmp /vim-airline-themes    /home/user/.vim/bundle/vim-airline-themes

# UID mapping
RUN apk add --no-cache shadow su-exec
COPY entrypoint.sh /entrypoint.sh
RUN adduser user; \
    chown -R user: /home/user

ENTRYPOINT ["/entrypoint.sh"]
