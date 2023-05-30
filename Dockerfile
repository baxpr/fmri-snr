# https://github.com/baxpr/fsl-base
# This base container has FSL and ImageMagick installed
FROM baxterprogers/fsl-base:v6.0.5.2

# Pipeline code
COPY README.md /opt/fmri-snr/README.md
COPY src /opt/fmri-snr/src
ENV PATH=/opt/fmri-snr/src:${PATH}

# Entrypoint
ENTRYPOINT ["fmri-snr.sh"]
