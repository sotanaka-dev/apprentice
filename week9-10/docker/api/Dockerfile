FROM ruby:3.2.2

WORKDIR /real-world

COPY real-world/Gemfile* ./

RUN bundle install
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g newman \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY docker/api/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

CMD ["rails", "server", "-b", "0.0.0.0"]
