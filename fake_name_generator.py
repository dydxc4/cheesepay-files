from faker import Faker
import random
import csv

fake = Faker('es_MX')  # Español de México

def generate_fake_name():
    first_name = fake.first_name()
    if first_name.find(' ') == -1 and random.random() < 0.5:
        first_name += ' ' + fake.first_name()
    return first_name

def generate_fake_data(n):
    data = []
    for _ in range(n):
        nombre = fake.first_name()
        apellido = fake.last_name()
        direccion = f"{fake.street_name()} #{random.randint(1, 999)}, {fake.city()}, Tijuana, {random.randint(10000, 99999)}"
        telefono = fake.phone_number()
        data.append({
            "Nombre": nombre,
            "Apellido": apellido,
            "Dirección": direccion,
            "Telefono": telefono
        })
    return data

def write_to_csv(data, filename):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        fieldnames = ['Nombre', 'Apellido', 'Dirección', 'Telefono']
        writer = csv.DictWriter(file, fieldnames=fieldnames, quotechar='\'', 
                                quoting=csv.QUOTE_ALL)
        
        writer.writeheader()
        for row in data:
            writer.writerow(row)


# Generar 10 registros falsos
registros = generate_fake_data(50)
write_to_csv(registros, 'registros_1.csv')
