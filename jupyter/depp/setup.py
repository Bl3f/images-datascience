from distutils.core import setup

setup(
    name='depp',
    version='0.0.1',
    description='Helper Python DEPP',
    author='Christophe Blefari',
    author_email='christophe.blefari@gmail.com',
    url='https://blef.fr',
    install_requires=[
        'requests',
        'boto3',
    ],
)