from distutils.core import setup

setup(
    name='depp',
    version='0.0.2',
    description='Helper Python DEPP',
    author='Christophe Blefari',
    author_email='christophe.blefari@gmail.com',
    url='https://blef.fr',
    packages=['depp'],
    install_requires=[
        'requests',
        'boto3',
        'pandas',
    ],
)