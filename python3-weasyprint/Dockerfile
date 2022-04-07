FROM python:3.8-alpine
RUN apk add gcc g++ cmake make mupdf-dev freetype-dev
ARG MUPDF=1.18.0
RUN ln -s /usr/include/freetype2/ft2build.h /usr/include/ft2build.h \
    && ln -s /usr/include/freetype2/freetype/ /usr/include/freetype \
    && wget -c -q https://www.mupdf.com/downloads/archive/mupdf-${MUPDF}-source.tar.gz \
    && tar xf mupdf-${MUPDF}-source.tar.gz \
    && cd mupdf-${MUPDF}-source \
    && make HAVE_X11=no HAVE_GLUT=no shared=yes prefix=/usr/local install \
    && cd .. \
    && rm -rf *.tar.gz mupdf-${MUPDF}-source
RUN pip install PyMuPDF==1.18.9
