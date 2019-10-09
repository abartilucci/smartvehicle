.data
 
slope_IN_buffer : .space 400 #Riservo 4B * 100 (=N rilevamenti + 100 spazi ) per il sensore di pendenza.
slope_IN_path:   .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/pendenzaIN.txt"
steer_IN_buffer : .space 300 #Riservo 3B * 100 (=N rilevamenti + 100 spazi) per il sensore di sterzata.
steer_IN_path:   .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/sterzoIN.txt"
dist_IN_buffer : .space 400 #Riservo 4B * 100 (=N rilevamenti + 100 spazi) per il sensore di distanza.
dist_IN_path:   .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/distanzaIN.txt"

slope_OUT_buffer : .space 200 #Riservo 2B * 100 (= N rilevamenti + 100 spazi) per il sensore di pendenza.
slope_OUT_path:   .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/correttezzaPendenzaOUT.txt"
steer_OUT_buffer : .space 200 #Riservo 2B * 100 (= N rilevamenti + 100 spazi) per il sensore di sterzata.
steer_OUT_path:   .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/correttezzaSterzoOUT.txt"
dist_OUT_buffer : .space 200 #Riservo 2B * 100 (= N rilevamenti + 100 spazi) per il sensore di distanza.
dist_OUT_path:   .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/correttezzaDistanzaOUT.txt"

pol_1_buffer : .space 200 #Riservo 2B * 100 (= N rilevamenti + 100 spazi) per la politica 1.
pol_1_path: .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/correttezzaP1.txt"
pol_2_buffer : .space 200 #Riservo 2B * 100 (= N rilevamenti + 100 spazi) per la politica 2.
pol_2_path: .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/correttezzaP2.txt"
pol_3_buffer : .space 200 #Riservo 2B * 100 (= N rilevamenti + spazi ) per la politica 3.
pol_3_path: .asciiz "/Users/abart/Documents/Universita/AE/Progetto2018/correttezzaP3.txt"

welcome: .asciiz "Welcome to the control unit of the car. \n"
unknwn_char : .asciiz "ALERT : Unknown value read from the sensor. \n"
start_S: .asciiz "Starting analyzis of Slope sensor... \n"
start_St: .asciiz "Starting analyzis of Steer sensor... \n"
start_D: .asciiz "Starting analyzis of Distance sensor... \n"
start_P1: .asciiz "Started computation of Policy 1. \n"
start_P2: .asciiz "Started computation of Policy 2. \n"
start_P3: .asciiz "Started computation of of Policy 3. \n"
completed_S: .asciiz "Completed Slope sensor computation test. \n"
completed_St: .asciiz "Completed Steer sensor computation test. \n"
completed_D: .asciiz "Completed Distance sensor computation test. \n"
complete: .asciiz "Program computation completed. Terminated execution."
correctness_array: .space 12 # riservo 3 word per i valori di correttezza

.text
.globl main


main: 			la $a0, welcome				# Stampa messaggio di benvenuto	
			jal printf
		
			la $t9, correctness_array		# $t9 contiene l'indirizzo di partenza dell'array da passare ai sensori
			
turnOn:			la $a0, start_S				# Stampa messaggio di inizio elaborazione sensore di pendenza		
			jal printf
				
			la $a1, ($t9)				# assegna a $a1 indirizzo di correctness_array da passare come argomento
			jal slope_S				# salta a istruzione di avvio sensore pendenza
			
			
			la $a0, start_St			# Stampa messaggio di inizio elaborazione sensore di sterzo
			jal printf
		
			la $a1, 4($t9)				# $a1 contiene l'indirizzo di partenza dell'array da passare ai sensori incrementato di 4
			jal steer_S				# salta a istruzione di avvio sensore di sterzo
			
			
			la $a0, start_D				# Stampa messaggio di inizio elaborazione sensore di distanza
			jal printf
			
			la $a1, 8($t9)				# $a1 contiene l'indirizzo di partenza dell'array da passare ai sensori incrementato di 8
			jal dist_S				# salta a istruzione di avvio sensore di distanza

			
			
			la $a0, start_P1			# Stampa messaggio di inizio elaborazione Policy 1
			jal printf
			
			la $a1, ($t9)				# $a1 contiene l'indirizzo di partenza dell'array da passare alla Policy 1
			jal P1					# salta a istruzione di avvio Policy 1
			
			
			
			la $a0, start_P2			# Stampa messaggio di inizio elaborazione Policy 2
			jal printf
			
			la $a1, ($t9)				# $a1 contiene l'indirizzo di partenza dell'array da passare alla Policy 2
			jal P2					# salta a istruzione di avvio Policy 2



			la $a0, start_P3			# Stampa messaggio di inizio elaborazione Policy 3
			jal printf				
				
			la $a1, ($t9)				# $a1 contiene l'indirizzo di partenza dell'array da passare alla Policy 3
			jal P3					# salta a istruzione di avvio Policy 3
								
					
engine_ON:		la $a1, ($t9)
			jal loop_Sl				# salta a istruzione di recupero sensore di pendenza
			
			la $a1, 4($t9)
			jal loop_St				# salta a istruzione di recupero sensore di sterzo
			
			la $a1, 8($t9)
			jal loop_D				# salta a istruzione di avvio sensore di distanza
			move $a3, $v0				# salva su $a3 0-flag di terminazione della lettura restituito come risultato dal sensore di distanza

			la $a1, ($t9)
			jal loop_P1				# salta a istruzione di avvio Policy 1
			move $a3, $v0				# salva su $a3 0-flag di uscita da Policy 1 restituito come risultato

			
			la $a1, ($t9)
			jal loop_P2				# salta a istruzione di avvio Policy 2
			move $a3, $v0				# salva su $a3 0-flag di uscita da Policy 2 restituito come risultato
			
			la $a1, ($t9)
			jal loop_P3				# salta a istruzione di avvio Policy 3
			beqz $v0, exit 				# se il risultato restituito attraverso $v0 e' 0, tutte le policy sono chiuse e chiudo il programma

			
			j engine_ON				# loop


slope_S: 		addi $sp, $sp,-24			# Alloco 24 byte su Stack
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno

			move $t1, $a1				# salvo su $t1 indirizzo di partenza array di correttezza passato come argomento
			
			la   $a0, slope_IN_path      		# filepath_IN per lettura da file
			jal open_file_r				# salta a procedura di apertura di file da leggere
			move $s0, $v0      			# $s0 contiene file_IN_Descriptor

			la   $a1, slope_IN_buffer   		# indirizzo di partenza del buffer di lettura
			jal read_from_file			# salta a procedura di lettura da file
			move $t3, $v0				# $t3 contiene numero di valori da leggere in input
			
			move $s1, $a1				# carico su $s1 l'indirizzo di partenza del buffer da leggere	
			lb $s2, ($s1)				# carico su $s2 il primo byte indirizzato dal buffer di lettura
	
			la   $a0, slope_OUT_path     		# filepath_OUT per scrittura su file
			jal open_file_w				# salta a procedura di scrittura su file
			move $t2, $v0      			# $t2 contiene file_OUT_Descriptor
				
			la $s7, slope_OUT_buffer		# carico su $s7 indirizzo di partenza del buffer_OUT
			j sign_check
		
							
loop_Sl	:		addi $sp, $sp, -24			# Alloco 24 byte su stack per ripristinare dati locali precedentemente memorizzati
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno

			lw $t3, 20($sp)				# ripristino da SF numero di valori residui da leggere in input
			lw $t2, 16($sp)				# ripristino da SF file_OUT_Descriptor
			lw $s0, 12($sp)				# ripristino da SF file_IN_Descriptor
			lw $s1, 8($sp)				# ripristino da SF buffer_IN_index
			lw $s7, 4($sp)				# ripristino da SF buffer_OUT_index	
			
			move $t1, $a1				# salvo su $t1 indirizzo di partenza array di correttezza passato come argomento
			
			blez $t3, close_slope			# se il numero di valori residui da leggere e' minore o pari a zero, termino l'esecuzione sul sensore
			lb $s2, ($s1)				# carico su $s2 il primo byte indirizzato dal buffer da leggere
		

sign_check:		bne $s2, 45, num_check 			# se avanza, allora è il simbolo ' - ' ( = 45 in ASCII )
			addi $s1, $s1, 1			# incremento l'indirizzo del buffer di lettura di una posizione
			sub $t3, $t3, 1				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 il byte successivo
			beq $s2, 45, unknown_char		# se avanza OK, altrimenti e' nuovamente il simbolo ' -' ERRORE

num_check: 		blt $s2, 48, unknown_char		# se il contenuto di $s2 < 0 ( = 48 in ASCII ) non appartiene al dizionario di interesse
			bgt $s2, 57, unknown_char		# se il contenuto si $s2 > 9 ( = 57 in ASCII )  non appartiene al dizionario di interesse
		
first_val:		bgt $s2, 53, sec_val			# se il contenuto di $s2 < 5 ( = 53 in ASCII ) passo al controllo dell'elemento successivo
			addi $s1, $s1, 2			# incremento di due posizioni l'indirizzo del buffer di lettura
			sub $t3, $t3, 2				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 2 byte indirizzato da buffer incrementato di due posizioni (3 cifra)
			bne $s2, 32, slope_NW			# se $s2 non contiene uno spazio ( = 32 in ASCII ) ho una lettura di un dato espresso (almeno) in centinaia = ERRORE
			j slope_W

sec_val:		addi $s1, $s1, 1			# incremento buffer_IN_index di una posizione
			sub $t3, $t3, 1				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 il byte indirizzato da buffer incrementato di una posizione
			beqz $s2, slope_W			# se $s2 contiene zero il file e' terminato, il sensore risulta funzionante
			bne $s2, 32, slope_NW			# se $s2 non contiene uno spazio ho una lettura di un input > 60 = ERRORE
			j slope_W
			
												
slope_NW:		li $t4, 48				# $t4 contiene il valore 0 in ASCII
			j write_slope			

				
slope_W:		li $t4, 49				# $t4 contiene il valore 1 in ASCII

			
write_slope:		sb $t4, ($t1)				# memorizzo il byte contenuto su $t4 nella prima locazione di memoria dell'array
			sb $t4, ($s7)				# memorizzo il byte contenuto su $t4 nella locazione di memoria puntata dal buffer di output	
			jal write_sensor			# salta a procedura di stampa del valore booleano nel file di output
			addi $s7, $s7, 1			# incremento buffer di uscita di una posizione
			
			beqz $t3, close_slope			# se il numero di valori da leggere e' zero, chiude l'operazione sul sensore
					
			li $t5, 32				# $t4 contiene lo spazio in codifica ASCII	
			sb $t5, ($s7)				# memorizzo il byte contenuto su $t4 nella locazione di memoria puntata dal buffer di output
			jal write_sensor			# salta a procedura di stampa del carattere spazio nel file di output
			addi $s7, $s7, 1			# incremento di una posizione il buffer di uscita
			
			
to_next:		addi $s1, $s1, 1			# incremento di una posizione buffer_IN_index
			sub $t3, $t3, 1				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 il byte indirizzato da buffer incrementato di una posizione
			beq $s2, 32, to_next			# se $s2 contiene uno spazio, scorro ancora, altrimenti salvo i registri e torno a main	

			
			sw $t3, 20($sp)				# salvo su SF numero di valori residui da leggere in input
			sw $t2, 16($sp)				# salvo su SF file_OUT_Descriptor
			sw $s0, 12($sp)				# salvo su SF file_IN_Descriptor
			sw $s1, 8($sp)				# salvo su SF buffer_IN_index
			sw $s7, 4($sp)				# salvo su SF buffer_OUT_index
			
			beqz $t3, close_slope			# se il numero di valori da leggere e' zero, chiude l'operazione sul sensore
			
			lw $ra, 0($sp)				# ripristino da SF indirizzo di ritorno del chiamante
			
			addi $sp, $sp, 24			# dealloco 24 byte da Stack
				
			jr $ra					# salto a istruzione contenuta in $ra 


						
steer_S:		sub $sp,$sp, 52 			# Alloco 52 byte su Stack
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
			
			move $t1, $a1				# salvo su $t1 indirizzo dell'array di correttezza passato come argomento	
		
		
			la   $a0, steer_IN_path      		# filepath_IN per lettura da file
			jal open_file_r				# salta a procedura di apertura file da leggere
			move $s0, $v0      			# $s0 contiene file_IN_Descriptor
			sw $s0, 16($sp)				# salvo su SF contenuto di $s0 nella locazione di memoria opportunamente assegnata
			
			la   $a1, steer_IN_buffer   		# indirizzo di partenza del buffer di lettura
			jal read_from_file			# salta a procedura di lettura da file
			move $t3, $v0				# memorizzo in $t3 numero di valori da leggere
			
			move $s1, $a1				# carico su $s1 l'indirizzo di partenza del buffer	
			lb $s2, ($s1)				# carico su $s2 il primo byte indirizzato dal buffer di lettura
			
			la   $a0, steer_OUT_path     		# filepath_OUT per scrittura su file
			jal open_file_w				# salta a procedura di scrittura su file
			move $t2, $v0      			# $t2 contiene file_OUT_Descriptor
			sw $t2, 20($sp)				# salvo su SF contenuto di $t2 nella locazione di memoria opportunamente assegnata

			
			la $s7, steer_OUT_buffer		# carico su $s7 indirizzo di partenza del buffer_OUT					
			j range_check


loop_St:		sub $sp,$sp, 52 			# Alloco 52 byte su Stack per ripristinare dati locali precedentemente memorizzati
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
			
			lw $t3,24($sp) 				# ripristino da SF numero di valori residui da leggere in input
			lw $t2,20($sp)				# ripristino da SF file_OUT_Descriptor
			lw $s0,16($sp)				# ripristino da SF file_IN_Descriptor
			lw $s1,12($sp)				# ripristino da SF buffer_IN_index
			lw $s7,8($sp)				# ripristino da SF buffer_OUT_index
			lw $s5,4($sp)				# ripristino da SF s(t-1) 
					
			move $t1, $a1				# salvo su $t1 indirizzo di partenza array di correttezza passato come argomento	
			
			blez $t3, close_steer			# se il numero di valori residui da leggere e' minore o pari a zero, termino l'esecuzione sul sensore
			lb $s2, ($s1)				# carico su $s2 il primo byte indirizzato dal buffer di lettura
			
			li $t6, 1				# $t6 ha il compito di flag per la prima accensione, in cui il sensore risulta funzionante se sono verificate tutte le specifiche, ad eccezione di quella riguardante la differenza con l'istante precedente
		
		
range_check: 		slti $t4, $s2, 48			
			bgtz $t4, unknown_char			# se il contenuto di $s2 < 0 ( = 48 in ASCII) allora si tratta di un elemento che non appartiene all'insieme numerico di interesse	
			slti $t4, $s2, 58			
			beqz $t4, unknown_char			# se il contenuto di $s2 < 10 ( = 58 in ASCII) allora si tratta di un numero del dizionario
		
sec_num:		addi $s1, $s1, 1			# incremento di una posizione buffer_IN_index
			sub $t3, $t3, 1				# decremento numero di valori da leggere
		
			lb $s2,($s1)				# carico su $s2 il byte indirizzato dal buffer di lettura incrementato di una posizione
			bne $s2, 32, third_num			# se il contenuto di $s2 non e' uno spazio analizzo l'elemento successivo, altrimenti il sensore risulta funzionante
			j steer_W	
		
		
third_num:		addi $s1, $s1, 1			# incremento di una posizione buffer_IN_index
			sub $t3, $t3, 1				# decremento numero di valori da leggere
		
			lb $s2,($s1)				# carico su $s2 il byte indirizzato dal buffer di lettura incrementato di una posizione
			bne $s2, 32, steer_NW			# se la terza cifra dell'input non e' uno spazio allora l'input e' dell'ordine delle centinaia = ERRORE
			sub $s1, $s1, 2				# resetto t0 alla prima posizione del numero
			addi $t3, $t3, 2				# ripristino numero di valori da leggere


str_to_int:		lb $s2,($s1)				# carico su $s2 il byte indirizzato dal buffer di lettura alla posizione precedente ai controlli (primo elemento)
			addi $s2, $s2, -48			# converte da ASCII a rappresentazione decimale il primo elemento dell'input
			mul $s2, $s2, 10			# moltiplico il primo elemento per 10 (decine)
			move $t5, $s2				# sposto contenuto di $s2 somma parziale della conversione, in $t5
		
			addi $s1, $s1, 1			# incremento di una posizione buffer_IN_index
			sub $t3, $t3, 1				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 il byte indirizzato dal buffer di lettura incrementato di una posizione
		
			addi $s2, $s2, -48			# converte da ASCII a rappresentazione decimale il secondo elemento dell'input
			addu $s6, $t5, $s2			# somma su $s6 i due numeri convertiti in rappresentazione decimale
			
			beqz $t6, steer_W			# se e' la prima esecuzione, il contenuto di $t6 risulta zero e il sensore funzionante


prev_check:		sub $t6, $s6, $s5			# sottrazione di s(t) - s(t-1) caricata su $t6
		
			slt  $t7, $t6, $zero      		# $t7 = ( t6 < 0 ? 1 : 0 )
   			bnez $t7, neg_val  			# se $t7 e' zero si tratta di un numero negativo
    			j pos_val  		
		
neg_val:		nor  $t6, $t6, $zero       		# complemento a uno di $t6, contenente numero negativo
    			addi $t6, $t6, 1        		# $t6 + 1 per ottenere valore assoluto della differenza 
					
pos_val:		ble $t6, 10, steer_W	 		# se |s(t) - s(t-1)| < = 10 il sensore rispetta le spefifiche e funziona
			

steer_NW:		li $a3, 48				# $a3 contiene il valore 0 in ASCII
			j write_steer
			
steer_W:		li $a3, 49				# $a3 contiene il valore 1 in ASCII
			
									
write_steer:		sb $a3, ($t1)				# memorizzo il byte contenuto su $a3 nella seconda locazione di memoria dell'array
			sb $a3, ($s7)				# memorizzo il byte contenuto su $a4 all'indirizzo puntato dal buffer di output
			jal write_sensor			# salta a procedura di stampa del valore booleano nel file di output
			addi $s7, $s7, 1			# incremento di una posizione il buffer di uscita
			beqz $t3, close_steer			# se il numero di valori da leggere e' zero, chiude l'operazione sul sensore
			
			li $t5, 32				# $t5 contiene lo spazio in codifica ASCII		
			sb $t5, ($s7)				# memorizzo il byte contenuto su $t5 nella locazione di memoria puntata dal buffer di output	
			jal write_sensor			# procedura per stampa del carattere spazio nel file di output
			addi $s7, $s7, 1			# incremento di una posizione il buffer di uscita
			
			move $s5, $s6				# sposto su $s5 contenuto di $s6, contentente s(t) che diventera' s(t-1) alla prossima lettura
		
to_nxt:			addi $s1, $s1, 1			# incremento di una posizione il buffer di uscita
			sub $t3, $t3, 1				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 il byte indirizzato dal buffer di lettura
			beq $s2, 32, to_nxt			# se $s2 contiene uno spazio, scorro ancora, altrimenti salvo i registri e torno a main

			sw $s5,4($sp)				# salvo su SF valore sensore istante precedente
			sw $s7,8($sp)				# salvo su SF buffer_OUT_index
			sw $s1,12($sp)				# salvo su SF buffer_IN_index
			sw $t3,24($sp)				# salvo su SF numero di valori residui da leggere in input per Steer
			
			lw $ra, 0($sp)				# ripristino da SF indirizzo di ritorno
			addi $sp,$sp, 52 			# dealloco 52 elementi da stack
			
			jr $ra					# salto a istruzione contenuta in $ra 
			

																																																																																																																																																																																																																			
dist_S:	 		sub $sp,$sp, 84				# alloco stack di 84 byte
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
			move $t1, $a1				# salvo su $t1 indirizzo dell'array di correttezza passato come argomento
			
			li $s3, 0				# registro per somma parziale conversione inizializzato a 0				
			li $s4, 2				# registro contatore del numero massimo di occorrenze di ostacoli mobili a stessa distanza accettabili

			li $s5, 0				# registro che conserva d(t-1) per ostacoli mobili
			sw $s5, 20($sp) 			# $s5 contiene inizialmente 0, poi valore sensore ostacolo mobile istante (t-1)
			 
			la   $a0, dist_IN_path      		# filepath_IN per lettura da file
			jal open_file_r				# salta a procedura di apertura di file da leggere
			move $s0, $v0      			# salvo in s0 il descrittore del file di IN
			sw $s0, 12($sp) 			# salvo su SF descrittore file IN di Dist
	
			la   $a1, dist_IN_buffer   		# indirizzo di partenza del buffer di lettura
			jal read_from_file			# salta a procedura di lettura da file
			move $t3, $v0				# $t3 contiene numero di valori da leggere
				
			move $s1, $a1				# carico su $s1 l'indirizzo di partenza del buffer da leggere		
			lb $s2, ($s1)				# carico su $s2 il primo byte indirizzato dal buffer di lettura

			
			la   $a0, dist_OUT_path     		# filepath_OUT per scrittura su file
			jal open_file_w				# salta a procedura di scrittura su file
			move $t2, $v0      			# $t2 contiene file_OUT_Descriptor
			sw $t2,24($sp) 				# salvo su SF file_OUT_Descriptor di Dist
				
			la $s7, dist_OUT_buffer			# asseggno a $s7 indirizzo di partenzadel buffer da cui scrivere il file di output	
				
			j lett_check		


loop_D:			sub $sp,$sp, 84 			# Alloco 84 byte su stack per ripristinare dati locali precedentemente memorizzati
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
					
			lw $t3,28($sp)				# ripristino da SF numero di valori residui da leggere in input per sensore attuale
			lw $t2,24($sp)				# ripristino da SF file_OUT_Descriptor
			lw $s5,20($sp)				# ripristino da SF valore s(t-1)
			lw $s4,16($sp)				# ripristino da SF flag ostacoli mobili a stessa distanza residui
			lw $s0,12($sp)				# ripristino da SF file_OUT_Descriptor
			lw $s1,8($sp)				# ripristino da SF buffer_IN_index
			lw $s7,4($sp)				# ripristino da SF buffer_OUT_index
	
			move $t1, $a1				# salvo su $t1 indirizzo di partenza array di correttezza passato come argomento		
			beq $t3, $zero, close_dist		# se il numero di valori residui e' pari a zero, termino l'esecuzione sul sensore
			lb $s2, ($s1)				# carico su $s2 il byte indirizzato dal buffer da leggere
			
			li $s3, 0				# inizializzo registro per somma parziale della conversione				
				

lett_check:		blt $s2, 65, unknown_char		# se il contenuto di $s2 < A ( = 65 in ASCII ) non appartiene al dizionario di interesse
			bgt $s2, 66, unknown_char		# se il contenuto di $s2 > B ( = 66 in ASCII ) non appartiene al dizionario di interesse
						
char_check:		addi $s1, $s1, 1			# incremento l'indirizzo del buffer di lettura di una posizione
			sub $t3, $t3, 1				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 il byte indirizzato dal buffer da leggere incrementato di una posizione
			
			beq $s2, 32, conversion_end		# se $s2 contiene uno spazio la conversione e' terminata, altrimenti itero
			beqz $s2, conversion_end		# se $s2 contiene il valore zero, fine lettura da input
			
			slti $t4, $s2, 65			# se il contenuto di $s2 < A ( = 65 in ASCII ), il secondo elemento dell'input non e' una lettera
			beqz $t4, is_letter			
			addi $s2, $s2, -48			# converte da ASCII (in rappresentazione esadecimale) a intero (in rappresentazione decimale) l'elemento successivo (numero)
			j normalize_in
						
			
is_letter:		slti $t4, $s2, 71			# se $s2 < 71, $t4 = 1, altrimenti $t4 = 0	
			beqz  $t4, unknown_char			# se il contenuto di $s2 >= G ( = 71 in ASCII ), il secondo elemento dell'input non e' una lettera del dizionario di interesse			 				
			addi $s2, $s2, -55			# converte da ASCII (in rappresentazione esadecimale) a intero (in rappresentazione decimale) l'elemento successivo (lettera)
			
				
normalize_in:		mul $s3, $s3, 16			# moltiplica per 16 per conversione in base esadecimale
			add $s3, $s3, $s2			# somma parziale della conversione
			j char_check



conversion_end:		beqz $s3, dist_NW			# se il contenuto di $s3, cioè d2(t)d3(t) = 0 ERRORE
			bgt $s3, 50, dist_NW			# se il contenuto di $s3, cioè d2(t)d3(t) > 50 ERRORE
				
			move $t6, $s1		 		# copio contenuto di $s1 buffer_IN_index, in $t5 
			sub $t6, $t6, 3				# decremento di due posizioni l'indiirzzo del buffer di lettura per tornare al primo elemento di ogni input ( = lettera 'A' o 'B')
			lb $s2, ($t6)				# carico su $s2 il byte indirizzato dal buffer $t6 da leggere
			
			beq $s2, 66, save_mov_obj		#  se il contenuto di $s2 e' 'B' passo al controllo di verifica per ostacoli mobili
				
			li $s4, 2				# resetta numero di occorrenze consecutive di ostacoli mobili a stessa distanza lecite
			j dist_W
									
			
save_mov_obj:		beq $s3, $s5, dist_check		# se il contenuto di $s3 equivale alla distanza letta del sensore all'istante precedente, salvato solamente in caso di ostacolo mobile, controllo che ci siano ancora occorrenze ostacoli mobili consecutivi concesse
			sw $s3, 20($sp)				# salvo il contenuto di $s3, cioè d2(t)d3(t) su SF alla locazione di memoria assegnata per la memorizzazazione del valore del sensore all'istante precedente
			li $s4, 2				# resetta numero di occorrenze consecutive di ostacoli mobili a stessa distanza lecite
			j dist_W

																				
dist_check:		sub $s4, $s4, 1				# decremento di un elemento registro contatore delle occorrenze consecutive per ostacoli mobili
			blez $s4, dist_error			# se il contenuto del registro $s4 e' pari a zero, allora non sono permesse nuove occorrenze per ostacoli mobili a stessa distanza	
			sw $s3, 20($sp)				# salvo il contenuto di $s3, cioe' d2(t)d3(t) su SF alla locazione di memoria assegnata per la memorizzazazione del valore del sensore all'istante precedente
			j dist_W
				
				
dist_error:		sw $s3, 20($sp)				# salvo il contenuto di $s3, cioe' d2(t)d3(t) su SF alla locazione di memoria assegnata per la memorizzazazione del sensore all'istante precedente


dist_NW:		li $t4, 48				# $t4 contiene il valore 0 in ASCII
			j write_dist

dist_W:			li $t4, 49				# $t4 contiene il valore 1 in ASCII


write_dist:		sb $t4, ($t1)				# memorizzo il valore della variabile booleana nella terza locazione di memoria dell'array di correttezza
			sb $t4, ($s7)				# memorizzo il byte contenuto su $t4 nella locazione di memoria puntata dal buffer di output
			jal write_sensor			# salta a procedura di stampa del valore booleano nel file di output
			addi $s7, $s7, 1			# incremento buffer di uscita di una posizione
			
			beqz $t3, close_dist			# se il numero di valori da leggere e' zero, chiude l'operazione sul sensore
					
			
			li $t5, 32				# $t4 contiene lo spazio in codifica ASCII	
			sb $t5, ($s7)				# memorizzo il byte contenuto su $t4 nella locazione di memoria puntata dal buffer di output
			jal write_sensor			# salta a procedura di stampa del carattere spazio nel file di output
			addi $s7, $s7, 1			# incremento posizione del buffer di output					
										
nxt_val:		addi $s1, $s1, 1			# incremento di una posizione buffer_IN_index
			sub $t3, $t3, 1				# decremento numero di valori da leggere
			lb $s2,($s1)				# carico su $s2 il byte indirizzato da buffer incrementato di una posizione
			beq $s2, 32, nxt_val			# se $s2 contiene uno spazio, scorro ancora, altrimenti salvo i registri e torno a main
			beqz $s2, close_dist			# se $s2 contiene 0, termino esecuzione sul sensore

			sw $s7, 4($sp)				# salvo su SF buffer_OUT_index
			sw $s1, 8($sp)				# salvo su SF buffer_IN_index
			sw $s4, 16($sp)				# salvo su SF numero occorrenze residue ostacoli mobili permessi
			sw $t3, 28($sp)				# salvo su SF numero di valori residui da leggere in input per Dist
	
			lw $ra, 0($sp)				# ripristino da SF registro di ritorno
			
			addi $sp,$sp, 84 			# dealloco 84 byte da stack
			
			jr $ra					# salto a istruzione contenuta in $ra 
				
			
			
P1:			sub $sp,$sp, 96				# Alloco 96 byte su stack
 			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno

			move $s3, $a1				# salvo su $t1 indirizzo dell'array di correttezza passato come argomento

			lb $t1, ($s3)				# carico su $t1 primo valore array correttezza
			lb $t2, 4($s3)				# carico su $t2 secondo valore array correttezza
			lb $t3, 8($s3)				# carico su $t3 terzo valore array correttezza

			la   $a0, pol_1_path     		# filepath_OUT per scrittura su file
			jal open_file_w				# salta a procedura di scrittura su file
			move $s0, $v0      			# $s0 contiene file_OUT_Descriptor
			sw $s0,4($sp) 				# salvo su SF file_OUT_Descriptor per P1												
 			
 			la $s1, pol_1_buffer			# carico su $s1 indirizzo di partenza del buffer_OUT per P1		
 			j P1_ex													
 					
 
loop_P1:		sub $sp,$sp, 96				# Alloco 96 byte su stack per ripristinare dati locali precedentemente memorizzati
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
			lw $s0, 4($sp) 				# carico da SF file_OUT_Descriptor per P1
			lw $s1, 8($sp) 				# carico da SF buffer_OUT_index per P1
			
			move $s3, $a1				# salvo su $s3 indirizzo dell'array di correttezza passato come argomento
			
			lb $t1, ($s3)				# carico su $t1 primo valore array correttezza
			lb $t2, 4($s3)				# carico su $t2 secondo valore array correttezza
			lb $t3, 8($s3)				# carico su $t3 terzo valore array correttezza


P1_ex:			and $t4, $t1, $t2			# AND bitwise tra primo e secondo valore correttezza
			and $t4, $t4, $t3			# AND bitwise tra risultato precedente e terzo valore correttezza
	
			sb $t4, ($s1)				# memorizzo il byte contenuto su $t4 nella locazione di memoria puntata dal buffer di output
			jal write_policy			# salta a procedura di stampa del valore booleano nel file di output
			addi $s1, $s1, 1			# incremento buffer di uscita di una posizione
			
			beqz $a3, exit_p1			# se il contenuto del registro $a3, passato come argomento e con funzione di 0-flag per identificare chiusura dell'ultimo sensore e' zero, chiudo la P1
				
			li $t5, 32				# $t4 contiene lo spazio in codifica ASCII	
			sb $t5, ($s1)				# memorizzo il byte contenuto su $t5 nella locazione di memoria puntata dal buffer di output
			jal write_policy			# salta a procedura di stampa del carattere spazio nel file di output
			addi $s1, $s1, 1			# incremento buffer di uscita di una posizione
			
			sw $s1,8($sp) 				# salvo su SF buffer_OUT_index per P1
			lw $ra, 0($sp)				# ripristino da SF indirizzo di ritorno del chiamante
			addi $sp,$sp, 96			# dealloco 96 byte da stack
			jr $ra					# salto a istruzione contenuta in $ra 
 			
			
P2:			sub $sp,$sp, 108			# Alloco 108 byte su stack
 			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
 			
 			move $s3, $a1				# salvo su $s3 indirizzo dell'array di correttezza passato come argomento

			lb $t1, ($s3)				# carico su $t1 primo valore array correttezza
			lb $t2, 4($s3)				# carico su $t2 secondo valore array correttezza
			lb $t3, 8($s3)				# carico su $t3 terzo valore array correttezza


			la   $a0, pol_2_path     		# filepath_OUT per scrittura su file
			jal open_file_w				# salta a procedura di scrittura su file
			move $s0, $v0      			# $s0 contiene file_OUT_Descriptor
			sw $s0,4($sp) 				# salvo su SF file_OUT_Descriptor per P2	
			
			la $s1, pol_2_buffer			# carico su $s1 indirizzo di partenza del buffer_OUT per P2
			sw $s1,8($sp) 				# salvo su buffer_OUT_ per P2
			
			j P2_ex	

						
loop_P2:		sub $sp,$sp, 108			# Alloco 108 byte su stack per ripristinare dati locali precedentemente memorizzati
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
			lw $s0, 4($sp) 				# carico da SF file_OUT_Descriptor per P2
			lw $s1, 8($sp) 				# carico da SF buffer_OUT_index per P2
			
			move $s3, $a1				# salvo su $s3 indirizzo dell'array di correttezza passato come argomento			
			
			lb $t1, ($s3)				# carico su $t1 primo valore array correttezza
			lb $t2, 4($s3)				# carico su $t2 secondo valore array correttezza
			lb $t3, 8($s3)				# carico su $t3 terzo valore array correttezza	
			
			
P2_ex:			and $t5, $t1, $t2			#  corr_P1 AND corr_P2 
			xor $t6, $t1, $t2			#  corr_P1 XOR corr_P2 = P1P2' + P1'P2			
			and $t7, $t3, $t6			#  corr_P3 AND ( P1P2' + P1'P2) )
			or $t5, $t5, $t7			#  (corr_P1 AND corr_P2) OR ( corr_P3 AND ( P1P2' + P1'P2 ) ) 
				
			sb $t5, ($s1)				# memorizzo il byte contenuto su $t5 nella locazione di memoria puntata dal buffer di output
			jal write_policy			# salta a procedura di stampa del valore booleano nel file di output
			addi $s1, $s1, 1			# incremento buffer di uscita di una posizione
			
			beqz $a3, exit_p2			# se il contenuto del registro $a3, passato come argomento e con funzione di 0-flag per identificare chiusura dell'ultimo sensore e' zero, chiudo P2
				
			li $t5, 32				# $t5 contiene lo spazio in codifica ASCII		
			sb $t5, ($s1)				# memorizzo il byte contenuto su $t5 nella locazione di memoria puntata dal buffer di output
			jal write_policy			# salta a procedura di stampa del carattere spazio nel file di output
			addi $s1, $s1, 1			# incremento buffer di uscita di una posizione
			
			sw $s1,8($sp) 				# salvo su SF file_OUT_Descriptor per P2
			lw $ra, 0($sp)				# ripristino da SF indirizzo di ritorno
			
			addi $sp,$sp,108			# dealloco 108 byte da stack
			jr $ra					# salto a istruzione contenuta in $ra 	
			
		
			
P3:			sub $sp,$sp, 120			# Alloco 120 byte su stack
 			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno

			move $s3, $a1				# salvo su $t1 indirizzo dell'array di correttezza passato come argomento

			lb $t1, ($s3)				# carico su $t1 primo valore array correttezza
			lb $t2, 4($s3)				# carico su $t2 secondo valore array correttezza
			lb $t3, 8($s3)				# carico su $t3 terzo valore array correttezza


			la   $a0, pol_3_path     		# filepath_OUT per scrittura su file
			jal open_file_w				# salta a procedura di scrittura su file
			move $s0, $v0      			# $s0 contiene file_OUT_Descriptor
			sw $s0,4($sp) 				# salvo su SF file_OUT_Descriptor per P3	
			
			la $s1, pol_3_buffer			# carico su $s1 indirizzo di partenza del buffer_OUT per P3
			sw $s1,8($sp) 				# salvo su SF buffer_OUT_index per P3
			
			j P3_ex		
			

loop_P3:		sub $sp,$sp, 120			# Alloco 108 byte su stack per ripristinare dati locali precedentemente memorizzati
			sw $ra, 0($sp)				# salvo su SF indirizzo di ritorno
			lw $s0, 4($sp) 				# carico da SF file_OUT_Descriptor per P3
			lw $s1, 8($sp) 				# carico da SF buffer_OUT_index per P3	
			
			move $s3, $a1				# salvo su $t1 indirizzo dell'array di correttezza passato come argomento			
			
			lb $t1, ($s3)				# carico su $t1 primo valore array correttezza
			lb $t2, 4($s3)				# carico su $t2 secondo valore array correttezza
			lb $t3, 8($s3)				# carico su $t3 terzo valore array correttezza
																																																																																																																																													
																									
P3_ex:			or $t4, $t2, $t3			# OR bitwise tra primo e secondo valore correttezza
			or $t5, $t4, $t1			# OR bitwise tra risultato precedente e terzo valore correttezza
			
			sb $t5, ($s1)				# memorizzo il byte contenuto su $t5 nella locazione di memoria puntata dal buffer di output
			jal write_policy			# salta a procedura di stampa del valore booleano nel file di output
			addi $s1, $s1, 1			# incremento buffer di uscita di una posizione
			
			beqz $a3, exit_p3			# se il contenuto del registro $a3, passato come argomento e con funzione di 0-flag per identificare chiusura dell'ultimo sensore e' zero, chiudo P3
				
			li $t5, 32				# $t4 contiene lo spazio in codifica ASCII	
			sb $t5, ($s1)				# memorizzo il byte contenuto su $t5 nella locazione di memoria puntata dal buffer di output
			jal write_policy			# salta a procedura di stampa del carattere spazio nel file di output
			addi $s1, $s1, 1			# incremento buffer di uscita di una posizione
			
			sw $s1,8($sp) 				# salvo su SF file_OUT_Descriptor per P3																																																																		
 			lw $ra, 0($sp)				# ripristino da SF indirizzo di ritorno
			
			addi $sp,$sp, 120			# dealloco 96 byte da stack
			jr $ra					# salto a istruzione contenuta in $ra																																
 																																								
 																																												
								
												
########################## Funzioni di supporto ##########################																
													
printf: 			li $v0, 4			# system call per stampa stringa
				syscall
				jr $ra
		
unknown_char: 			la $a0, unknwn_char
				jal printf
				
				
open_file_r:			li   $v0, 13       		# system call per apertura del file
				li   $a1, 0        		# flag per lettura
				li   $a2, 0        		# modalita e' ignorata
				syscall            		# chiamata di sistema
				jr $ra				
				
open_file_w:			li   $v0, 13       		# system call per apertura del file di output
				li   $a1, 1       		# flag per scrittura
				li   $a2, 0        		# modalita ignorata
				syscall				# chiamata di sistema	
				jr $ra           	
				
read_from_file:			li   $v0, 14       		# system call per lettura del file
				move $a0, $s0      		# descrittore del file  
				li   $a2,  400  		# numero massimo di valori da leggere
				syscall      			# chiamata di sistema
				jr $ra		

write_policy:			li   $v0, 15       		# system call per scrittura su file
				move $a0, $s0      		# descrittore del file
				move $a1, $s1      		# indirizzo a partire dal quale scrivere
				li $a2, 1			# numero di caratteri da scrivere
				syscall            		# syscall per scrittura su file
				jr $ra

write_sensor:			li   $v0, 15       		# system call per scrittura su file
				move $a0, $t2      		# descrittore del file OUT
				move $a1, $s7      		# indirizzo a partire dal quale scrivere
				li   $a2, 1       		# dimensione buffer
				syscall            		# syscall per scrittura su file
				jr $ra


close_slope:			lw $t2, 16($sp)			# ripristino da SF descrittore file OUT
				lw $s0, 12($sp)			# ripristino da SF descrittore file IN
				
				jal close_sensor		# salta a procedura di chiusura operazioni I/O su sensore
				
				la $a0, completed_S		# Stampa messaggio di completamento sensore pendenza	
				jal printf
				
				lw $t3, 20($sp)			# ripristino da SF numero di valori da leggere
				lw $s1, 8($sp)			# ripristino da SF buffer_IN_index
				lw $s7, 4($sp)			# ripristino da SF buffer_OUT_index
				lw $ra, 0($sp)			# ripristino da SF indirizzo di ritorno
				
				addi $sp,$sp, 24		# Dealloco lo stack utilizzato
				jr $ra
		

close_steer:			lw $t2, 20($sp)			# ripristino da SF descrittore file OUT
				lw $s0, 16($sp)			# ripristino da SF descrittore file IN
				
				jal close_sensor		# salta a procedura di chiusura operazioni I/O su sensore
				
				la $a0, completed_St		# Stampa messaggio di completamento sensore sterzo
				jal printf

				lw $t3, 24($sp) 		# ripristino da SF numero di valori da leggere
				lw $s1, 12($sp)			# ripristino da SF buffer_IN_index
				lw $s7, 8($sp)			# ripristino da SF buffer_OUT_index
				lw $s5, 4($sp)			# ripristino da SF valore sensore istante precedente
				lw $ra, 0($sp)			# ripristino da SF indirizzo di ritorno per chiamante
				
				addi $sp,$sp, 52		# Dealloco lo stack utilizzato
				jr $ra

				
close_dist:			lw $t2, 24($sp)			# ripristino da SF descrittore file OUT
				lw $s0, 12($sp)			# ripristino da SF descrittore file IN
				
				jal close_sensor		# salta a procedura di chiusura operazioni I/O su sensore
				
				la $a0, completed_D
				jal printf
				
				lw $t3, 28($sp)			# ripristino da SF numero di valori da leggere
				lw $s5, 20($sp)			# ripristino da SF valore s(t-1)
				lw $s4, 16($sp)			# ripristino da SF numero occorrenze residue ostacoli mobili permessi
				lw $s1, 8($sp) 			# ripristino da SF buffer_IN_index
				lw $s7, 4($sp) 			# ripristino da SF buffer_OUT_index	
				lw $ra, 0($sp)			# ripristino da SF indirizzo di ritorno per chiamante
				
				addi $sp,$sp, 84		# Dealloco lo stack utilizzato
		
				move $v0, $zero			# restituisce zero come risultato per indicare terminazione operazioni di I/O sui sensori
				jr $ra
				

close_sensor:			li   $v0, 16       		# system call per chiusura del file di output
    				move $a0, $t2     		# descrittore del file di OUTPUT 
    				syscall
			
				li   $v0, 16       		# system call per chiusura del file di input
    				move $a0, $s0      		# descrittore del file di INPUT
    				syscall 
    				jr $ra		
    																			
exit_p1:			li $t8, 1
				j exit_p

exit_p2:			li $t8, 2
				j exit_p

exit_p3:			li $t8, 3
				

exit_p:				lw $s0,4($sp)			# dealloco da SF file_OUT_Descriptor di P1/P2/P3...
				lw $s1,8($sp)			# dealloco da SF buffer_OUT_index di P1/P2/P3...
				
				li   $v0, 16       		# system call per chiusura del file di output
    				move $a0, $s0     		# descrittore del file di OUTPUT 
    				syscall
    				
    				lw $ra, 0($sp)			# ripristino da SF indirizzo di ritorno		
    				
    				beq $t8, 1, incr_P1		# opportuno incremento per corretta deallocazione P1	
    				beq $t8, 2, incr_P2		# opportuno incremento per corretta deallocazione P2	
    				beq $t8, 3, incr_P3		# opportuno incremento per corretta deallocazione P3	
    				
 	incr_P1:		addi $sp, $sp, 96		# dealloco stack di 96 byte
 				j end_exitP
 				
 	incr_P2:		addi $sp, $sp, 108		# dealloco stack di 108 byte
 				j end_exitP		
 				
 	incr_P3: 		addi $sp, $sp, 120		# dealloco stack di 120 byte		
    			
  
 	end_exitP:  		move $v0, $zero			# imposto il contenuto di $v0 a zero
 				jr $ra				# salto a istruzione contenuta in $ra 


exit: 				la $a0, complete		# stampa stringa di terminazione programma		
				jal printf
				li $v0, 10  			# Chiude il programma
    				syscall 	
