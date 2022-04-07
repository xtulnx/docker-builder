FROM python:3.8-alpine
# RUN apk add gcc g++ cmake make mupdf-dev freetype-dev
# ARG MUPDF=1.18.0
# RUN ln -s /usr/include/freetype2/ft2build.h /usr/include/ft2build.h \
#     && ln -s /usr/include/freetype2/freetype/ /usr/include/freetype \
#     && wget -c -q https://www.mupdf.com/downloads/archive/mupdf-${MUPDF}-source.tar.gz \
#     && tar xf mupdf-${MUPDF}-source.tar.gz \
#     && cd mupdf-${MUPDF}-source \
#     && make HAVE_X11=no HAVE_GLUT=no shared=yes prefix=/usr/local install \
#     && cd .. \
#     && rm -rf *.tar.gz mupdf-${MUPDF}-source
# RUN pip install PyMuPDF==1.18.9

# Add temporary virtual environment dependencies
RUN apk --no-cache add --virtual .builddeps gcc g++

# These dependency packages cannot be removed because they continue to be used in PyMupdf
RUN apk --no-cache add  mupdf-dev freetype-dev jbig2dec-dev jpeg-dev openjpeg-dev 

# install PyMupdf
RUN pip install pymupdf

# Remove virtual environment dependencies
RUN apk del .builddeps
